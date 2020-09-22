# -*- encoding : ASCII-8BIT -*-
#! /usr/bin/ruby

TEST_DIR = File.dirname __FILE__
$: << "#{TEST_DIR}/../lib"

require 'test/unit'
require 'mapi/msg'
require 'mapi/convert'

class TestMsg < Test::Unit::TestCase
  def test_blammo
    Mapi::Msg.open "#{TEST_DIR}/test_Blammo.msg" do |msg|
      assert_equal '"TripleNickel" <TripleNickel@mapi32.net>', msg.from
      assert_equal 'BlammoBlammo', msg.subject
      assert_equal 0, msg.recipients.length
      assert_equal 0, msg.attachments.length
      # this is all properties
      assert_equal 66, msg.properties.raw.length
      # this is unique named properties
      assert_equal 48, msg.properties.to_h.length
      # test accessing the named property keys - same name but different namespace
      assert_equal 'Yippee555', msg.props['Name4', Ole::Types::Clsid.parse('55555555-5555-5555-c000-000000000046')]
      assert_equal 'Yippee666', msg.props['Name4', Ole::Types::Clsid.parse('66666666-6666-6666-c000-000000000046')]
    end
  end


  def test_rendered_string_is_valid_encoding
    msg = Mapi::Msg.open "#{TEST_DIR}/multipart-with-html.msg" do |msg|
      string_version = msg.to_mime.to_s
      if string_version.respond_to?(:valid_encoding?)
        assert_equal true, string_version.valid_encoding?
      end
    end
  end

  def test_multipart_rendered_string_is_valid_encoding
    msg = Mapi::Msg.open "#{TEST_DIR}/small-business-rates-relief.msg" do |msg|
      string_version = msg.to_mime.to_s
      if string_version.respond_to?(:valid_encoding?)
        assert_equal true, string_version.valid_encoding?
      end
    end
  end

  def test_non_multipart_rendered_string_is_valid_encoding
    msg = Mapi::Msg.open "#{TEST_DIR}/28101-outlook-attachment.msg" do |msg|
      string_version = msg.to_mime.to_s
      if string_version.respond_to?(:valid_encoding?)
        assert_equal true, string_version.valid_encoding?
      end
    end
  end

  def test_embedded_msg_renders_as_string
    msg = Mapi::Msg.open "#{TEST_DIR}/embedded.msg" do |msg|
      assert_match "message/rfc822", msg.to_mime.to_s
    end
  end
end

