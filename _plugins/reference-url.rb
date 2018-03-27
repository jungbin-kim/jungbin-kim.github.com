# Title: Reference from url for Jekyll
# Author: Jungbin Kim
#
# Description:
#   Given a url, outputs the meta data of url's html.
#
# Syntax: {% reference targetURL %}
#
# Examples:
#
# Input: {% reference https://blog.jungbin.kim/notes/2018-03-08-ruby-libs-get-html-meta/ %}
# Input: {% reference /notes/2018-03-08-ruby-libs-get-html-meta/ %}

require 'metainspector'
require 'uri'

module Jekyll
  class ReferenceURL < Liquid::Tag
    def initialize(tag_name, url, tokens)
      unless url.match(/^http/) || url.match(/^https/)
        baseURL = Jekyll.configuration({})['url']
        url = "#{baseURL}#{url}"
      end
      @target_url = url.strip
    end

    def render(context)
      page = MetaInspector.new(@target_url)
      meta = page.meta

      title = page.best_title
      description = page.best_description
      image = page.images.best || ''

      %{
        <div style="font-family:Verdana; font-size:16px; width:100%; border: solid 1px rgba(0,0,0,0.13);">
           <table style="table-layout:auto;border-collapse:collapse;">
              <tr style="vertical-align:top;">
                 <td width="112" style="padding-top:9px; border-bottom:0px;"><img src="#{image}" alt="no file" width="112"></td>
                 <td style="padding-left:16px; border-bottom:0px;">
                    <table>
                       <tr>
                          <td style="border-bottom:0px;">
                            <a href="#{@target_url}" target="_blank" title="#{@target_url}">
                                <h2 style="margin:0; font-size:16px;">#{title}</h2>
                            </a>
                          </td>
                       </tr>
                       <tr>
                          <td style="word-wrap:break-word;border-bottom:0px;font-size:13px;">#{description}</td>
                       </tr>
                    </table>
                 </td>
              </tr>
           </table>
        </div>
      }.gsub(/\s+/, " ").strip
    end
  end
end

Liquid::Template.register_tag('reference', Jekyll::ReferenceURL)