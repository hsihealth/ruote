#--
# Copyright (c) 2005-2009, John Mettraux, jmettraux@gmail.com
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
#
# Made in Japan.
#++


module Ruote

  module Condition

    SET_REGEX = /(\S*?)( +is)?( +not)?( +set)$/
    COMPARISON_REGEX = /(.*?) *(==|!=|>=|<=|>|<|=~) *(.*)/

    def self.skip? (sif, sunless)

      return (not true?(sif)) if sif
      return (true?(sunless)) if sunless

      false
    end

    # TODO : rconditional

    def self.true? (conditional)

      conditional = unescape(conditional)

      if m = SET_REGEX.match(conditional)
        eval_is(m[1..-1])
      elsif m = COMPARISON_REGEX.match(conditional)
        m[1].send(m[2], m[3])
      else
        to_b(conditional)
      end
    end

    protected

    def self.eval_is (match)

      is_set = match.pop.strip != ''
      negative = match.find { |m| m == ' not' }

      negative ? (not is_set) : is_set
    end

    def self.unescape (s)

      s ? s.to_s.gsub('&amp;', '&').gsub('&gt;', '>').gsub('&lt;', '<') : nil
    end

    #def self.ruby_eval (s)
    #  treechecker.check_conditional(s)
    #  eval(s)
    #end

    def self.to_b (o)

      o = o.strip if o.is_a?(String)

      not (o == nil || o == false || o == 'false' || o == '')
    end
  end
end
