==========
rygel.conf
==========

----------------------------
Configuration file for Rygel
----------------------------

:Manual section: 5

SYNOPSIS
=========


  - ``/etc/rygel.conf``
  - ``$XDG_CONFIG_HOME/rygel.conf``

DESCRIPTION
===========
    Rygel reads its configuration values from the file
    $XDG_CONFIG_HOME/rygel.conf or a file given on command line with the
    --config option. If that file does not exist, it uses the file
    /etc/rygel.conf. Most of the options may be overriden by commandline
    arguments or environment variables. See rygel(1) for details on those.
    
    Lists in the configuration file are separated by a semicolon(;). Boolean
    values must be either the text true or the text false.

GENERAL DIRECTIVES
==================

    *ipv6*
        Set to *false* if you do not want Rygel to run on IPv6 addresses.
        Whether or not IPv6 is actually supported depends on how GUPnP was
        configured.

    *enable-transcoding*
        Set to *false* if you want to disable transcoding of audio and video

    *video-upload-folder*
        Where video files should be saved if allow-upload is true. It defaults
        to @VIDEOS@, which expands to the standard videos folder (typically
        ${HOME}/Videos)

    *music-upload-folder*
        Where music files should be saved if allow-upload is true. It defaults
        to @MUSIC@, which expands to the standard videos folder (typically
        ${HOME}/Music)

    *picture-upload-folder*
        Where picture files should be saved if allow-upload is true. It defaults
        to @PICTURES@, which expands to the standard videos folder (typically
        ${HOME}/Pictures)

    *media-engine*
        Default media engine to load. If not specified, the engine folder is
        searched recursively and the first engine found is loaded.

    *interface*
        List of network interfaces to attach rygel to. You can also use network
        IP or even ESSID for wireless networks on Linux. Leave it blank for
        dynamic configuration.

    *port*
        Set the listen port for the HTTP server. 0 means to dynamically chose a
        port.

    *log-level*
        Comma-separated list of domain:level pairs. This allows to specify log
        level thresholds infividually for different domains. Valid domains are
        "rygel" for anything not a plugin,  "*" for everything or the name of a
        plugin.
        
        The available levels are 1 to 5, with 1 only logging critical errors and
        5 being debug logging. All levels include messages of the levels below.
        
        To see log messages of level 5, it is also necessary to set the
        environment variable G_MESSAGES_DEBUG to all to get any output.

    *allow-upload*
        Whether clients should be allowed to upload media files to the server.

    *allow-deletion*
        Whether clients should be allowed to delete media files from the server.

    *force-downgrade-for*
        Semicolon-separated list of device user agents (or parts thereof) that
        need a downgrade in the UPnP device versions.
        
        Warning: ONLY change this setting when told to do so or when you know
        what you are doing If you find that adding your device makes it working
        with Rygel, please file an issue at
        https://gitlab.gnome.org/GNOME/rygel/issues/new/?issuable_template=IOP
        so we can include it in future releases.

    *acl-fallback-policy*
        Access control fall-back policy if no access control provider could be
        found. The default value is true, which will allow any peer to access
        everything.

    *strict-dlna*
        If set to true, Rygel will disable various features that improve
        compatibility with many clients, but break standard conformance.

DATABASE SETTINGS
=================

    Generic options for the database support library

    *debug*
        Set to true for extended SQL output

GSTREAMER MEDIA ENGINE
======================

    These settings are specific for the GStreamer Media Engine. This is the
    default engine, refer to the ``media-engine`` setting. The following options
    are available

    *transcoders*
        A semicolon-separated list of active transcoders. This setting has no
        effect if enable-transcoding is set to false.
        
        Possible values are lpcm,mp3,mp2ts,aac,avc or wmv.

ENERGYMANAGEMENT SERVICE SETTINGS
=================================

    These settings are available when ``energy-management`` is enabled for a
    plugin

    *mode-on-suspend*
        The NetworkInterfaceMode that should be used when suspended. Valid
        values are "Unimplemented", "IP-up-Periodic", "IP-down-no-Wake", "IP-
        down-with-WakerOn", "IP-down-with-WakeAuto" or "IP-down-with-
        WakeOnAuto".

    *supported-transport*
        Optional WakeSupportTransport that the service should advertise. Valid
        values are "UDP-Broadcast", "UDP-Unicast", "TCP-Unicast" or "Other".

    *password*
        Optional hexadecimal password that will be used to build the WakeOn
        pattern.

PLUGIN-SPECIFIC SETTINGS
========================

    Sections for plugins are denoted with ``[PluginName]`` and can contain
    options specific to a plugin, or any of these common options

    *title*
        Title of the device implemented by this plugin.
        
        There are some variables which will be replaced by rygel. @REALNAME@
        will be substituted by the user's real name, @USERNAME@ by the user's
        login name, @HOSTNAME@ by the name of the machine rygel runs on, and
        @PRETTY_HOSTNAME@ the system description from /etc/machine-info if
        available, otherwise it's equivalent to @HOSTNAME@.

    *enabled*
        You can individually enable or disable plugions by setting this to true
        or false

    *uuid*
        Instead of having a plugin generate an UUID on its own, it is possible
        to pass a fixed UUID through the configuration. Format is a plain UUID,
        NOT an UDN.

    *energy-management*
        Set to true if you would like the UPnP device to contain an
        EnergyManagement service. Note that additional settings are required
        then, see the section on EnergyManagement below.

SECTION RENDERER
================

    Generic options for the renderer framework, independent of the back-end

    *image-timeout*
        Default showtime in seconds to use for images in playlists if
        dlna:lifetime is not set. DLNA wants something between 5 and 15 seconds.

SECTION LOCALSEARCH
===================

    The LocalSearch plugin uses the centralized database of meta information
    from the LocalSearch project, using the TinySparql library.  See
    https://tracker.gnome.org for more information.


    *only-export-from*
        Restrict the exported media items to files that are located in any of
        the folders listed. This setting supports the usual @ patterns for path
        substitution.

    *share-pictures*
        Enable or disable sharing of all pictures found in the LocalSearch
        database, filtered for the list of folders in only-export-from.

    *share-videos*
        Enable or disable sharing of all videos found in the LocalSearch
        database, filtered for the list of folders in only-export-from.

    *share-music*
        Enable or disable sharing of all music found in the LocalSearch
        database, filtered for the list of folders in only-export-from.

    *strict-sharing*
        When enabled, only files that have a DLNA profile (nmm:dlnaProfile) will
        be exported. Improves compatibility with the DLNA standard, but
        potentially filters out a lot of media files.

SECTION MEDIAEXPORT
===================

    The MediaExport plugin is an alternative to the localsearch-backed media
    export. It extracts meta-data by itself and stores it in a SQLite database
    under ``$XDG_CACHE_HOME/rygel/media-export.db``.
    
    %%Note: If both plugins, LocalSearch as well as MediaExport, are enabled,
    MediaExport will disable itself in favour of the LocalSearch plugin.


    *uris*
        A list of if URIs to expose via UPnP. It may be files, folder or
        anything supported by GVFS. If left empty it defaults to export the
        user's music, video and picture folders as defined by the XDG special
        user directories spec. These default folders can be referenced by
        @MUSIC@, @PICTURES@ and @VIDEOS@. Locations can be entered as either
        fully escaped URIs or normal paths.
        
        An example for uris could be uris=@MUSIC@;/home/user/My
        Pictures;file:///home/user/My%20Videos
        
        Note: If you enter a normal path that contains whitespace, there is no
        need to escape them with either a backslash or putting the string in
        quotes.
        
        Note: It is strongly advised against using an exported folder as a
        target for downloads when extract-metadata is enabled. Rygel will most
        likely ignore the files then because they will fail to extract while the
        download is ongoing.

    *extract-metadata*
        Whether MediaExport should query and store meta-data from the media
        files

    *monitor-changes*
        Whether MediaExport should monitor the locations given in `uris` for
        modifications

    *monitor-grace-timeout*
        How long MediaExport should wait to start meta-data extraction after it
        has been notified about a file change

    *virtual-folders*
        Whether MediaExport should show generated folders based off of file
        meta-data

SECTION PLAYBIN
===============

    Playbin is a default implementation of a DLNA Media Renderer, using
    GStreamer. It allows minimal customisation of the sinks used in the
    renderer. For example, to configure an audio-only renderer, set "audio-sink"
    to "autoaudiosink" and "video-sink" to "fakesink".


    *audio-sink*
        Override the default audiosink for the playbin used in the renderer

    *video-sink*
        Override the default videosink for the playbin in the renderer

SECTION GSTLAUNCH
=================

    The GstLaunch plugin allows to export GStreamer Pipelines using the syntax
    from the `gst-launch` commandline utility. It is able to export more than
    one pipeline. You have to omit the sink which is provided by Rygel.
    
    Available items have to be declared using the "launch-items" setting. Each
    pipeline then needs to be configured for the three values of "launch",
    "mime", and "title". For example, given the setting of ``launuch-
    items=audio;video`` it is necessary to also define triplets of ``audio-
    title``, ``audio-mime``, ``audio-launch`` and ``video-title``, ``video-
    mime`` and ``video-launch``.


SECTION MPRIS
=============

    MPRIS allows you to turn any media player that implements MPRIS control into
    a DLNA/UPnP renderer by converting UPnP calls to MPRIS and vice-versa. If
    you want to disable MPRIS integration for some players, e.g. if they do not
    support setting the URL through MPRIS, you can add a section with the name
    of the MPRIS endpoint as shown in Rygel's log and set enable to false


SECTION ORG.MPRIS.MEDIAPLAYER2.IO.BASSI.AMBEROL
===============================================

    Example of disabling a specific player for MPRIS integration


SECTION EXTERNAL
================

    Similar to MPRIS the External plugin allows applications that expose the
    MediaServer2 D-Bus specification converted into a DLNA server.

