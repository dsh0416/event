# Copyright, 2021, by Samuel G. D. Williams. <http://www.codeotaku.com>
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

require_relative 'selector/select'

module Event
	# These constants are the same as those defined in IO.
	READABLE = 1
	PRIORITY = 2
	WRITABLE = 4
	
	module Selector
		def self.default(env = ENV)
			if name = env['EVENT_SELECTOR']&.to_sym
				if Event::Selector.const_defined?(name)
					return Event::Selector.const_get(name)
				else
					warn "Could not find EVENT_SELECTOR=#{name}!"
				end
			end
			
			if self.const_defined?(:URing)
				return Event::Selector::URing
			elsif self.const_defined?(:KQueue)
				return Event::Selector::KQueue
			elsif self.const_defined?(:EPoll)
				return Event::Selector::EPoll
			else
				return Event::Selector::Select
			end
		end
		
		def self.new(*args)
			default.new(*args)
		end
	end
end
