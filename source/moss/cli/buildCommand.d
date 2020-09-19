/*
 * This file is part of moss.
 *
 * Copyright © 2020 Serpent OS Developers
 *
 * This software is provided 'as-is', without any express or implied
 * warranty. In no event will the authors be held liable for any damages
 * arising from the use of this software.
 *
 * Permission is granted to anyone to use this software for any purpose,
 * including commercial applications, and to alter it and redistribute it
 * freely, subject to the following restrictions:
 *
 * 1. The origin of this software must not be misrepresented; you must not
 *    claim that you wrote the original software. If you use this software
 *    in a product, an acknowledgment in the product documentation would be
 *    appreciated but is not required.
 * 2. Altered source versions must be plainly marked as such, and must not be
 *    misrepresented as being the original software.
 * 3. This notice may not be removed or altered from any source distribution.
 */

/**
 * Build command implementation
 */
module moss.cli.buildCommand;
import moss.cli;

import moss.format.binary;

static ExitStatus buildExecute(ref Processor p)
{
    import std.stdio;

    auto writer = Writer(File("testpackage.stone", "wb"));
    writer.fileType = MossFileType.Binary;

    auto meta = MetaPayload();
    meta.addRecord(RecordTag.Name, "nano");
    meta.addRecord(RecordTag.Release, cast(uint64_t) 1000);
    meta.addRecord(RecordTag.Version, "5.2");
    meta.addRecord(RecordTag.Summary, "Small, friendly text editor inspired by Pico");
    meta.addRecord(RecordTag.Description, "GNU nano is an easy-to-use text editor originally designed as a replacement for Pico, the ncurses-based editor from the non-free mailer package Pine (itself now available under the Apache License as Alpine).");
    meta.addRecord(RecordTag.Homepage, "https://www.nano-editor.org/");
    meta.addRecord(RecordTag.License, "GPL-3.0-or-later");

    auto content = ContentPayload();
    content.addFile("6aad886e25795d06dfe468782caac1d4991a9b4fca7f003d754d0b326abb43dc", "LICENSE");
    content.addFile("7ae82e48f6a61aacf94e3b56172e292bcfe9d19d1b45ea31ae5354b0bf8f2802",
            "README.md");

    meta.compression = PayloadCompression.Zlib;
    content.compression = PayloadCompression.Zstd;
    writer.addPayload(cast(Payload*)&content);
    writer.addPayload(cast(Payload*)&meta);
    writer.flush();

    stderr.writeln("Writer test");
    return ExitStatus.Failure;
}

const Command buildCommand = {
    primary: "build", secondary: "bi", blurb: "Build a package", usage: "build [spec]",
    exec: &buildExecute, helpText: `
Build a binary package from the given package specification file. It will
be built using the locally available build dependencies and the resulting
binary packages (.stone) will be emitted to the output directory, which
defaults to the current working directory.
`
};
