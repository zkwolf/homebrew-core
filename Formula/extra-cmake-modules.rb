class ExtraCmakeModules < Formula
  desc "Extra modules and scripts for CMake"
  homepage "https://api.kde.org/frameworks/extra-cmake-modules/html/index.html"
  url "https://download.kde.org/stable/frameworks/5.86/extra-cmake-modules-5.86.0.tar.xz"
  sha256 "aacc5ccdc5799efe34e2dae33418c379466caf7c9802b78348ccfb5782fe6ab5"
  license all_of: ["BSD-2-Clause", "BSD-3-Clause", "MIT"]
  head "https://invent.kde.org/frameworks/extra-cmake-modules.git"

  # We check the tags from the `head` repository because the latest stable
  # version doesn't seem to be easily available elsewhere.
  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b266c5ef465ebd7274c9520a57bedb4de8cda3b191fffb20a5de89e39a64489b"
    sha256 cellar: :any_skip_relocation, big_sur:       "94a885f1fefa3124584d4a318e83bbb835a253c1cd7ae52d22f83aa088d33b1d"
    sha256 cellar: :any_skip_relocation, catalina:      "94a885f1fefa3124584d4a318e83bbb835a253c1cd7ae52d22f83aa088d33b1d"
    sha256 cellar: :any_skip_relocation, mojave:        "94a885f1fefa3124584d4a318e83bbb835a253c1cd7ae52d22f83aa088d33b1d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "614600c436a66b578bd75a98d691a471d814234716accf8aea6807a0f33d916e"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "qt@5" => :build
  depends_on "sphinx-doc" => :build

  def install
    args = std_cmake_args
    args << "-DBUILD_HTML_DOCS=ON"
    args << "-DBUILD_MAN_DOCS=ON"
    args << "-DBUILD_QTHELP_DOCS=ON"
    args << "-DBUILD_TESTING=OFF"

    system "cmake", ".", *args
    system "make", "install"
  end

  test do
    (testpath/"CMakeLists.txt").write("find_package(ECM REQUIRED)")
    system "cmake", ".", "-Wno-dev"

    expected="ECM_DIR:PATH=#{HOMEBREW_PREFIX}/share/ECM/cmake"
    assert_match expected, File.read(testpath/"CMakeCache.txt")
  end
end
