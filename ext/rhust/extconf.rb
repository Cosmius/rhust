require "mkmf"
require "find"

module MakeMakefile
  def create_makefile2(target, srcprefix = nil)
    $target = target
    libpath = $DEFLIBPATH|$LIBPATH
    message "creating Makefile\n"
    MakeMakefile.rm_f "#{CONFTEST}*"

    if target.include?('/')
      target_prefix, target = File.split(target)
      target_prefix[0,0] = '/'
    else
      target_prefix = ""
    end

    srcprefix ||= "$(srcdir)/#{srcprefix}".chomp('/')
    RbConfig.expand(srcdir = srcprefix.dup)

    orig_srcs = Dir[File.join(srcdir, 'Cargo.{toml,lock}')]
    # orig_srcs.concat Dir[File.join(srcdir, 'src/*.rs')]
    # orig_srcs = []
    Find.find(srcdir) do |p|
      if (not FileTest.directory?(p)) && p.end_with?('.rs')
        orig_srcs.push(p)
      end
    end
    srcs = []
    $distcleandirs << File.join(srcdir, "target")

    dllib = target ? "$(TARGET).#{CONFIG['DLEXT']}" : ""
    mfile = open("Makefile", "wb")
    conf = configuration(srcprefix)
    conf = yield(conf) if block_given?
    mfile.puts(conf)
    mfile.print "
libpath = #{($DEFLIBPATH|$LIBPATH).join(" ")}
LIBPATH = #{libpath}

CLEANFILES = #{$cleanfiles.join(' ')}
DISTCLEANFILES = #{$distcleanfiles.join(' ')}
DISTCLEANDIRS = #{$distcleandirs.join(' ')}

extout = #{$extout && $extout.quote}
extout_prefix = #{$extout_prefix}
target_prefix = #{target_prefix}
LOCAL_LIBS = #{$LOCAL_LIBS}
LIBS = #{$LIBRUBYARG} #{$libs} #{$LIBS}
ORIG_SRCS = #{orig_srcs.join(' ')}
SRCS = $(ORIG_SRCS) #{(srcs - orig_srcs).join(' ')}
TARGET = #{target}
TARGET_NAME = #{target && target[/\A\w+/]}
TARGET_ENTRY = #{EXPORT_PREFIX || ''}Init_$(TARGET_NAME)
DLLIB = #{dllib}
EXTSTATIC = #{$static || ""}
STATIC_LIB = #{staticlib unless $static.nil?}
#{!$extout && defined?($installed_list) ? "INSTALLED_LIST = #{$installed_list}\n" : ""}
TIMESTAMP_DIR = #{$extout ? '$(extout)/.timestamp' : '.'}
" #"
    # TODO: fixme
    install_dirs.each {|d| mfile.print("%-14s= %s\n" % d) if /^[[:upper:]]/ =~ d[0]}
    n = ($extout ? '$(RUBYARCHDIR)/' : '') + '$(TARGET)'
    mfile.print "
CARGO_SO      = $(srcdir)/target/release/lib$(DLLIB)
CARGO_MF      = $(srcdir)/Cargo.toml

TARGET_SO     = #{($extout ? '$(RUBYARCHDIR)/' : '')}$(DLLIB)
CLEANLIBS     = #{n}.#{CONFIG['DLEXT']} #{config_string('cleanlibs') {|t| t.gsub(/\$\*/) {n}}}
CLEANOBJS     = *.#{$OBJEXT} #{config_string('cleanobjs') {|t| t.gsub(/\$\*/, "$(TARGET)#{deffile ? '-$(arch)': ''}")} if target} *.bak

all:    #{$extout ? "install" : target ? "$(DLLIB)" : "Makefile"}
static: #{$extmk && !$static ? "all" : "$(STATIC_LIB)#{!$extmk ? " install-rb" : ""}"}
.PHONY: all install static install-so install-rb
.PHONY: clean clean-so clean-static clean-rb

#{CLEANINGS}

$(CARGO_SO): $(SRCS)
\tcargo build --release --manifest-path $(CARGO_MF)

$(DLLIB): $(CARGO_SO)
\t$(COPY) $(CARGO_SO) $(DLLIB)

install: $(DLLIB) $(TIMESTAMP_DIR)/.RUBYARCHDIR.-.rhust.time
\t$(INSTALL_PROG) $(DLLIB) $(RUBYARCHDIR)

$(TIMESTAMP_DIR)/.RUBYARCHDIR.-.rhust.time:
\t$(Q) $(MAKEDIRS) $(@D) $(RUBYARCHDIR)
\t$(Q) $(TOUCH) $@

"

  ensure
    mfile.close if mfile
  end
end

create_makefile2 'rhust/rhust'
