# test_image.rb: Unit tests for the PNM library.
#
# Copyright (C) 2013 Marcus Stollsteimer

require 'minitest/spec'
require 'minitest/autorun'
require 'pnm'


describe PNM::Image do

  before do
    srcpath = File.dirname(__FILE__)
    @bilevel_path = File.expand_path("#{srcpath}/temp.pbm")
    @grayscale_path = File.expand_path("#{srcpath}/temp.pgm")
    @color_path = File.expand_path("#{srcpath}/temp.ppm")

    pixels = [[0,0,0,0,0],
              [0,1,1,1,0],
              [0,0,1,0,0],
              [0,0,1,0,0],
              [0,0,1,0,0],
              [0,0,0,0,0]]
    @bilevel = PNM::Image.new(:pbm, pixels)

    pixels = [[  0, 50,100,150],
              [ 50,100,150,200],
              [100,150,200,250]]
    @grayscale = PNM::Image.new(:pgm, pixels, {:maxgray => 250})

    pixels = [[[0,6,0], [1,5,1], [2,4,2], [3,3,4], [4,2,6]],
              [[1,5,2], [2,4,2], [3,3,2], [4,2,2], [5,1,2]],
              [[2,4,6], [3,3,4], [4,2,2], [5,1,1], [6,0,0]]]
    @color = PNM::Image.new(:ppm, pixels, {:maxgray => 6})
  end

  it 'can create a color image from gray values' do
    image = PNM::Image.new(:ppm, [[0,3,6], [3,6,9]])
    image.info.must_match %r{^PPM 3x2 Color}
    image.pixels.must_equal [[[0,0,0], [3,3,3], [6,6,6]], [[3,3,3], [6,6,6], [9,9,9]]]
  end

  it 'can be written to an ASCII encoded file' do
    @bilevel.write(@bilevel_path, :ascii)
    @grayscale.write(@grayscale_path, :ascii)
    @color.write(@color_path, :ascii)

    File.delete(@bilevel_path)
    File.delete(@grayscale_path)
    File.delete(@color_path)
  end

  it 'can return image information' do
    @bilevel.info.must_equal 'PBM 5x6 Bilevel'
    @grayscale.info.must_equal 'PGM 4x3 Grayscale'
    @color.info.must_equal 'PPM 5x3 Color'
  end
end