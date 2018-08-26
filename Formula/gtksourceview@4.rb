class GtksourceviewAT4 < Formula
  desc "Text view with syntax, undo/redo, and text marks"
  homepage "https://projects.gnome.org/gtksourceview/"
  url "https://download.gnome.org/sources/gtksourceview/4.0/gtksourceview-4.0.2.tar.xz"
  sha256 "15829fc728f74e2005e2fc65c2aada4b223f3b361b2200b7e02ff7a9014b5fac"

  bottle do
    sha256 "c738e9a67ed3d3dd457b91efe0ad0e416835e37291306c582ad9d21b8d89c395" => :mojave
    sha256 "90df7061e6dee49a9c29094f477b9db19639ce77497294c145529cd4031ff317" => :high_sierra
    sha256 "920c8c6023eff56dceefc105212b8bc9c408e380cd46556110b5a88107887896" => :sierra
    sha256 "ae4e361b65ea527647cf0aa58969517f5a8d559f82e5fe549e22bfe484e47b4a" => :el_capitan
  end

  depends_on "intltool" => :build
  depends_on "pkg-config" => :build
  depends_on "vala" => :build
  depends_on "gobject-introspection" => :build
  depends_on "gettext"
  depends_on "gtk+3"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-vala=yes",
                          "--enable-gobject-introspection=yes"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <gtksourceview/gtksource.h>

      int main(int argc, char *argv[]) {
        gchar *text = gtk_source_utils_unescape_search_text("hello world");
        return 0;
      }
    EOS
    ENV.libxml2
    atk = Formula["atk"]
    cairo = Formula["cairo"]
    fontconfig = Formula["fontconfig"]
    freetype = Formula["freetype"]
    gdk_pixbuf = Formula["gdk-pixbuf"]
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    gtkx3 = Formula["gtk+3"]
    libepoxy = Formula["libepoxy"]
    libpng = Formula["libpng"]
    pango = Formula["pango"]
    pixman = Formula["pixman"]
    flags = %W[
      -I#{atk.opt_include}/atk-1.0
      -I#{cairo.opt_include}/cairo
      -I#{fontconfig.opt_include}
      -I#{freetype.opt_include}/freetype2
      -I#{gdk_pixbuf.opt_include}/gdk-pixbuf-2.0
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/gio-unix-2.0/
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{gtkx3.opt_include}/gtk-3.0
      -I#{include}/gtksourceview-4
      -I#{libepoxy.opt_include}
      -I#{libpng.opt_include}/libpng16
      -I#{pango.opt_include}/pango-1.0
      -I#{pixman.opt_include}/pixman-1
      -D_REENTRANT
      -L#{atk.opt_lib}
      -L#{cairo.opt_lib}
      -L#{gdk_pixbuf.opt_lib}
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{gtkx3.opt_lib}
      -L#{lib}
      -L#{pango.opt_lib}
      -latk-1.0
      -lcairo
      -lcairo-gobject
      -lgdk-3
      -lgdk_pixbuf-2.0
      -lgio-2.0
      -lglib-2.0
      -lgobject-2.0
      -lgtk-3
      -lgtksourceview-4.0
      -lintl
      -lpango-1.0
      -lpangocairo-1.0
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
