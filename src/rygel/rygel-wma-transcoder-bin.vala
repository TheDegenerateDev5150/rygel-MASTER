/*
 * Copyright (C) 2009 Jens Georg <mail@jensge.org>.
 *
 * Author: Jens Georg <mail@jensge.org>
 *
 * This file is part of Rygel.
 *
 * Rygel is free software; you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * Rygel is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program; if not, write to the Free Software Foundation,
 * Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.
 */
using Gst;

internal class Rygel.WMATranscoderBin : Gst.Bin {
    private const string DECODEBIN = "decodebin2";

    private const string AUDIO_SRC_PAD = "audio-src-pad";
    private const string AUDIO_SINK_PAD = "audio-sink-pad";

    private dynamic Element audio_enc;

    public WMATranscoderBin (MediaItem     item,
                             Element       src,
                             WMATranscoder transcoder) throws Error {
        Element decodebin = GstUtils.create_element (DECODEBIN, DECODEBIN);

        this.audio_enc = transcoder.create_encoder (item,
                                                    AUDIO_SRC_PAD,
                                                    AUDIO_SINK_PAD);

        this.add_many (src, decodebin, this.audio_enc);
        src.link (decodebin);

        var src_pad = this.audio_enc.get_static_pad (AUDIO_SRC_PAD);
        var ghost = new GhostPad (null, src_pad);
        this.add_pad (ghost);

        decodebin.pad_added += this.decodebin_pad_added;
    }

    private void decodebin_pad_added (Element decodebin, Pad new_pad) {
        Pad enc_pad = this.audio_enc.get_pad (AUDIO_SINK_PAD);
        if (!new_pad.can_link (enc_pad)) {
            return;
        }

        if (new_pad.link (enc_pad) != PadLinkReturn.OK) {
            var error = new GstError.LINK (_("Failed to link pad %s to %s"),
                                           new_pad.name,
                                           enc_pad.name);
            GstUtils.post_error (this, error);

            return;
        }
    }
}
