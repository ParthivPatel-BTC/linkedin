require 'nokogiri'
require 'open-uri'

class ScrapperController < ApplicationController
	before_action :authenticate_user!
	def new
	end

	def create
		if params[:url].present?
			begin
				@profile = Linkedin::Profile.new(params[:url], { company_details: true, proxy_ip: '127.0.0.1', proxy_port: '3128', username: 'demo dev', password: 'demo@123' })
			rescue Exception => e
				puts "======>message start"
				logger.error e.message
				puts "======>message end"
				flash[:notice] = "Profile not found. Please try with different profile URL"
				redirect_to new_scrapper_path	
			end
			if @profile.present?
				header = "PROSPECT CODE, MINING DATE, CALLING DATE, DOMAIN, INDUSTRY SEGMENT, FUNCTIONS, FIRST NAME, LAST NAME, DESIGNATION, ORGANIZATION, EMAIL, WORK PHONE, WEBSITE, CITY, STATE, COUNTRY, PERSONAL WEBSITE"
				dir = Dir.mkdir("#{Rails.root}/profiles") unless Dir.exists?("#{Rails.root}/profiles")
				file = File.new("#{Rails.root}/profiles/linkedin-profiles.csv", "a") 
				unless File.exist?(File.dirname(file))
				  FileUtils.mkdir_p(File.dirname(file))
				end
				city_state_country = Nokogiri::HTML(open(params[:url])).at_css(".locality").text.split(",")
		    File.open(file, "a:UTF-16LE:UTF-8") do |csv|
		    	file_last_line = IO.readlines("#{Rails.root}/profiles/linkedin-profiles.csv", "a")
		    	csv << header unless file_last_line.first.present?
		    	csv.write "\n"
		    	csv << ","
		    	csv << Time.now.strftime("%d/%^b/%Y")
		    	csv << ","
		    	csv << ","
		    	csv << ","
		    	csv << ","
		    	csv << ","
		    	csv << @profile.first_name
		    	csv << ","
		    	csv << @profile.last_name
		    	csv << ","
		    	csv << @profile.current_companies.first[:title]
		    	csv << ","
		    	csv << @profile.current_companies.first[:company]
		    	csv << ","
		    	csv << ","
		    	csv << ","
		    	csv << ","
		    	csv << @profile.location rescue nil
		    	csv << ","
		    	csv << city_state_country[1] rescue nil
		    	csv << ","
		    	csv << @profile.country rescue nil
		    	csv << ","
		    	csv << @profile.linkedin_url rescue nil
		    end
		    flash[:success] = "Profile details has been added successfully"
		  	redirect_to new_scrapper_path
			end
		end
	end

	def download_excel
		send_file "#{Rails.root}/profiles/linkedin-profiles.csv", :type => 'application/vnd.ms-excel; charset=utf-8'
	end

	def delete_file
		if FileUtils.rm_rf("#{Rails.root}/profiles")
			flash[:success] = 'File deleted successfully'
		else
			flash[:notice] = 'File not deleted. Please try again.'
		end
		redirect_to new_scrapper_path
	end
end
