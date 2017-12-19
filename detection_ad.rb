#!/usr/bin/ruby
# -*- coding: UTF-8 -*-

require 'rubygems'  
require 'selenium-webdriver' 
require 'spreadsheet'
# require 'chromedriver-helper'


#--------------------------------------------------------
#web_url:the web page url
#--------------------------------------------------------
web_file = "weburl.txt"

Spreadsheet.client_encoding = "UTF-8" 
excel_fil = Spreadsheet::Workbook.new  
sheet = excel_fil.create_worksheet :name => "ads_show"

# driver = Selenium::WebDriver.for :chrome
driver = Selenium::WebDriver.for :firefox
$web_num = 1
$all_ads_num = 0
$hide_ads_num = 0

#--------------------------------------------------------
#driver = Selenium::WebDriver.for :chrome
#web_url_para = web_url
#sheet = excel_fil.create_worksheet :name => "ads_show"
#web_num = web_num
#--------------------------------------------------------
def search_ads (driver, web_url_para, sheet)
	web_url = web_url_para
	#--------------------------------------------------------
	#web_url_domain:the domian of the web page
	#--------------------------------------------------------
	web_url_domain_raw = web_url.match(/https?\:\/\/(.*?)\/.*?/)
	web_url_domain = web_url_domain_raw[1]

	
	driver.get web_url
	sleep 3

	#--------------------------------------------------------
	#get <iframe ...>...<\iframe>
	#--------------------------------------------------------
	html_source = driver.page_source
	match_iframe = html_source.scan(/(<\s*iframe\s.*?>.*?<\s*\/\s*iframe\s*>)/)

	#--------------------------------------------------------
	#select the third party hide ads url from iframe.src
	#iframe_src_hide:hide ad url
	#ad_hide_num: number
	#--------------------------------------------------------
	iframe_src_hide_raw = match_iframe.map do |ifr|
		if (src_match = ifr[0].to_s.match(/(<\s*iframe\s.*?(src=\"(.*?)\".*?>))/) )
			src_matched_hide = src_match[1].gsub(/\&amp\;/,"&")
			hide_condition_1 = src_matched_hide.match(/.*?\swidth\s*\=\s*\"\s*0\s*px\s*\"\s.*?height\s*=\s*\"\s*0\s*px\s*\".*/)
			hide_condition_2 = src_matched_hide.match(/.*?\sheight\s*\=\s*\"\s*0\s*px\s*\"\s.*?width\s*=\s*\"\s*0\s*px\s*\".*/)
			hide_condition_3 = src_matched_hide.match(/.*?style\s*=\s*\".*?width\s*:\s*0\s*px\s*;.*?height\s*:\s*0\s*px.*?\"/)
			hide_condition_4 = src_matched_hide.match(/.*?style\s*=\s*\".*?height\s*:\s*0\s*px\s*;.*?width\s*:\s*0\s*px.*?\"/)
			hide_condition_5 = src_matched_hide.match(/.*?\sdisplay\s*=\s*\"\s*none\s*\"\s*/)
			hide_condition_6 = src_matched_hide.match(/.*?style\s*=\s*\".*?display\s*:\s*none\s*.*?\"/)
			if (hide_condition_1 || hide_condition_2 || hide_condition_3 || hide_condition_4 || hide_condition_5 || hide_condition_6)
				# alert("123");
				src_matched = src_match[3].gsub(/\&amp\;/,"&")
				src_matched = src_matched.match(/https?\:\/\/(.*)\/.*/)
				if src_matched
					domain_judge_raw = src_matched[0].to_s.match(/https?\:\/\/(.*?)\/.*?/)
					domain_judge = domain_judge_raw[1]
					if domain_judge.to_s == web_url_domain.to_s
						#the same domain
						src_matched = nil
					else
						#not the same domain
						src_matched[0]
					end
				end
			else
				src_matched = nil
			end
		end
	end
	iframe_src_hide = iframe_src_hide_raw.compact
	ad_hide_num = iframe_src_hide.size
	$hide_ads_num = $hide_ads_num + ad_hide_num

	#--------------------------------------------------------
	#select the third party ads url from iframe.src
	#iframe_src:ad url
	#ad number
	#--------------------------------------------------------
	iframe_src_show_raw = match_iframe.map do |ifr|	
		if (src_match = ifr[0].to_s.match(/(<\s*iframe\s.*?(src=\"(.*?)\".*?>))/) )
			src_matched_hide = src_match[1].gsub(/\&amp\;/,"&")

			hide_condition_1 = src_matched_hide.match(/.*?\swidth\s*\=\s*\"\s*0\s*px\s*\"\s.*?height\s*=\s*\"\s*0\s*px\s*\".*/)
			hide_condition_2 = src_matched_hide.match(/.*?\sheight\s*\=\s*\"\s*0\s*px\s*\"\s.*?width\s*=\s*\"\s*0\s*px\s*\".*/)
			hide_condition_3 = src_matched_hide.match(/.*?style\s*=\s*\".*?width\s*:\s*0\s*px\s*;.*?height\s*:\s*0\s*px.*?\"/)
			hide_condition_4 = src_matched_hide.match(/.*?style\s*=\s*\".*?height\s*:\s*0\s*px\s*;.*?width\s*:\s*0\s*px.*?\"/)
			hide_condition_5 = src_matched_hide.match(/.*?\sdisplay\s*=\s*\"\s*none\s*\"\s*/)
			hide_condition_6 = src_matched_hide.match(/.*?style\s*=\s*\".*?display\s*:\s*none\s*.*?\"/)

			unless (hide_condition_1 || hide_condition_2 || hide_condition_3 || hide_condition_4 || hide_condition_5 || hide_condition_6)
				src_matched = src_match[3].gsub(/\&amp\;/,"&")
			 	src_matched = src_matched.match(/https?\:\/\/(.*)\/.*/)
				if src_matched
					domain_judge_raw = src_matched[0].to_s.match(/https?\:\/\/(.*?)\/.*?/)
					domain_judge = domain_judge_raw[1]
					if domain_judge.to_s == web_url_domain.to_s
						#the same domain
						src_matched = nil
					else
						#not the same domain
						src_matched[0]
					end
				end
			else
				src_matched = nil
			end 

		end
	end
	iframe_src_show = iframe_src_show_raw.compact
	ad_show_num = iframe_src_show.size

	#--------------------------------------------------------
	#all ads 
	#--------------------------------------------------------
	iframe_src = iframe_src_hide + iframe_src_show
	ad_num = iframe_src.size

	$all_ads_num = $all_ads_num + ad_num
	



	#--------------------------------------------------------
	#select ad domian 
	#src_domain:ad url domain
	#--------------------------------------------------------
	src_domain_raw = iframe_src.map do |sr|	
		if (domain_match = sr.to_s.match(/https?\:\/\/(.*?)\/.*?/) )
			domain_matched = domain_match[1]
		end
	end
	src_domain = src_domain_raw.compact

	#--------------------------------------------------------
	#file operation
	#--------------------------------------------------------

	# time = Time.now
	# time_stamp = "-" + time.month.to_s  + time.day.to_s + "_" + time.hour.to_s + time.min.to_s + time.sec.to_s
	# sheet_name = web_url_domain.to_s + time_stamp
	
	# book = Spreadsheet::Workbook.new  
	# shee2 = book.create_worksheet :name => 'My Second Worksheet' 
	# sheet = excel_fil.worksheet 0 


	sheet[$web_num + 0,0] = "Web url"
	sheet[$web_num + 0,1] = web_url
	sheet[$web_num + 1,0] = "The num of ads"
	sheet[$web_num + 1,1] = ad_num
	sheet[$web_num + 1,2] = "The num of hide ads"
	sheet[$web_num + 1,3] = ad_hide_num
	sheet[$web_num + 2,0] = "The url domain of ads"
	sheet[$web_num + 2,1] = "The url of ads" + "(The top " + String(ad_hide_num) + " are hidden ads)"
	ad_num.times do |n|
		i = n + 3 + $web_num
		sheet[i,0] = src_domain[n]
		sheet[i,1] = iframe_src[n]
	end
	$web_num = $web_num + ad_num + 3 + 1
	puts "This page has searched successfully: #{web_url_para}"

end

File.open(web_file) do |fil|
	if fil
		fil.each do |url|
			begin
				search_ads(driver, url, sheet)
			rescue
				puts "This page has searched unsuccessfully: #{url}"
				puts "Please waiting process..."
				driver.quit
				# driver = Selenium::WebDriver.for :chrome
				driver = Selenium::WebDriver.for :firefox
				puts "Start the next web url"
				next
			end
		end
	end
end


sheet[0,0] = "The ads number of all pages"
sheet[0,1] = $all_ads_num
sheet[0,2] = "The hide ads number of all pages"
sheet[0,3] = $hide_ads_num

excel_fil.write "ad_file.xls"




# fil = File.open("ad_show.txt","a+")
# fil.puts "web page url: #{web_url}"
# fil.puts "the number of ads: #{ad_num}"
# ad_num.times do |n|
# 	i = n + 1
# 	fil.puts "the url_domain-->url of ad_#{i}: #{src_domain[i]} --> #{iframe_src[i]}"
# end
# fil.puts "---------------------------------------------------------------------------"
# fil.close

puts "Detection is complete!"

driver.quit  