require "spec_helper"

RSpec.describe Rise::Constants do
  it "has a version number" do
    expect(Rise::Constants::VERSION).not_to be nil
  end

  it "is the correct domain" do
    expect(DOMAIN).to eq('rise.sh')
  end

  it "is an integer and equal to `8080`" do
    expect(UPLOAD_PORT).to eq(8080)
  end

  it "is rise-cli" do
    expect(Rise::Constants::NAME).to eq('rise-cli')
  end

  it "bcrypt installation is OK" do
    expect(BCrypt::Password.create('password')).to eq('$2a$10$JxM8RWjXRgUbsPjNO73D/OJ3U8IY7hADwBBeHA1k3SqPkAO79xGNK')
  end
end
