class Rise < Formula
  desc "Simple serverless deployment"
  homepage "https://rise.sh"
  url "https://github.com/cbrnrd/rise.git"
  version "0.1.7"
  head "https://github.com/cbrnrd/rise.git"
  bottle :unneeded
  depends_on :ruby => "2.4"

  def install
    bin.install "bin/rise"
  end

  test do
    system "rubocop", "--fail-level", "W"
  end
end
