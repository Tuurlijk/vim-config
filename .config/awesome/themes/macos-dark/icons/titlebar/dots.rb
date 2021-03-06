#!/usr/bin/ruby
# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'yaml'

path = "#{File.dirname(__FILE__)}"

configuration = {}
if File.exist?(path + '/dots.yml')
	configuration = YAML::load(File.read(path + '/dots.yml')) || {}
end

def hasOptipng
	return system('optipng -v > /dev/null')
end

def drawCircle(dot, defaults)
	translate = (defaults['canvasSize'] / 2).to_s
	edge = defaults['canvasSize'].to_s
	strokeWidth = dot['strokeWidth'] || defaults['strokeWidth']
	radius = dot['radius'] || defaults['radius']

	# Generate base image
	system("convert -size " + edge + "x" + edge + " xc:none \
						-stroke '#" + dot['stroke'] + "' \
						-fill '#" + dot['fill'] + "' \
						-strokewidth " + strokeWidth.to_s + " \
						-draw 'translate " + translate + "," + translate + " circle 0,0 " + radius.to_s + ",0' \
						" + dot['name'] + ".png")

	# Compress image
	if hasOptipng
		system('optipng -o7 ' + dot['name'] + '.png')
	end

	# Copy image to its filenames
	dot['filenames'].each do |name|
		system('cp ' + dot['name'] + '.png ' + name)
	end

	# Remove base image
	system('unlink ' + dot['name'] + '.png ')
end

configuration['dots'].each do |dot|
	drawCircle(dot, configuration['defaults'])
end

