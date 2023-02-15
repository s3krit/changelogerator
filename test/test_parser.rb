# frozen_string_literal: true

require_relative '../lib/label'
require 'test/unit'

class TestParser < Test::Unit::TestCase
  def test1
    lbl = Label.new('B2-foo')
    assert_equal('B', lbl.letter)
    assert_equal(2, lbl.number)
    assert_equal('foo', lbl.description)
  end

  def test_no_desc
    lbl = Label.new('B2-')
    assert_equal('B', lbl.letter)
    assert_equal(2, lbl.number)
    assert_equal(nil, lbl.description)
  end

  def test_no_dash
    lbl = Label.new('B2')
    assert_equal('B', lbl.letter)
    assert_equal(2, lbl.number)
    assert_equal(nil, lbl.description)
  end

  def test_double_digits
    lbl = Label.new('B12-foo')
    assert_equal('B', lbl.letter)
    assert_equal(12, lbl.number)
    assert_equal('foo', lbl.description)
  end

  def test_spacing1
    lbl = Label.new('B2 -foo')
    assert_equal('B', lbl.letter)
    assert_equal(2, lbl.number)
    assert_equal('foo', lbl.description)
  end

  def test_spacing2
    lbl = Label.new('B2- foo')
    assert_equal('B', lbl.letter)
    assert_equal(2, lbl.number)
    assert_equal('foo', lbl.description)
  end

  def test_spacing3
    lbl = Label.new('B2   -         foo')
    assert_equal('B', lbl.letter)
    assert_equal(2, lbl.number)
    assert_equal('foo', lbl.description)
  end

  def test_description_with_spaces1
    lbl = Label.new('B2-foo bar')
    assert_equal('B', lbl.letter)
    assert_equal(2, lbl.number)
    assert_equal('foo bar', lbl.description)
  end

  def test_description_with_spaces2
    lbl = Label.new('B2-  foo bar')
    assert_equal('B', lbl.letter)
    assert_equal(2, lbl.number)
    assert_equal('foo bar', lbl.description)
  end

  def test_description_with_emojis
    lbl = Label.new('B2-foo bar 😄😄😄')
    assert_equal('B', lbl.letter)
    assert_equal(2, lbl.number)
    assert_equal('foo bar 😄😄😄', lbl.description)
  end

  def test_case1
    lbl = Label.new('b2-foo Bar')
    assert_equal('B', lbl.letter)
    assert_equal(2, lbl.number)
    assert_equal('foo Bar', lbl.description)
  end

  def test_case_no_label
    assert_raises InvalidLabel, 'xxx' do
      Label.new('123-foo')
    end
  end

  def test_leading_zeroes
    lbl = Label.new('A00099-foo')
    assert_equal('A', lbl.letter)
    assert_equal(99, lbl.number)
    assert_equal('foo', lbl.description)
  end
end
