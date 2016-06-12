require 'nokogiri'
require 'open-uri'

class ScrapperController < ApplicationController
	before_action :authenticate_user!
	def new
	end

	def create
		if params[:url].present?
			begin
				@profile = Linkedin::Profile.new(params[:url])
			rescue Exception => e
				flash[:notice] = "Profile not found. Please try with different profile URL"
				redirect_to new_scrapper_path	
			end
			if @profile.present?
				header = "First Name, Last Name, Designation, Organization, Linkedin Profile, City, State, Country"
				dir = Dir.mkdir("#{Rails.root}/profiles") unless Dir.exists?("#{Rails.root}/profiles")
				file = File.new("#{Rails.root}/profiles/linkedin-profile.xlsx", "a") 
				unless File.exist?(File.dirname(file))
				  FileUtils.mkdir_p(File.dirname(file))
				end
				city_state_country = Nokogiri::HTML(open(params[:url])).at_css(".locality").text.split(",")
		    File.open(file, "a:UTF-16LE:UTF-8") do |csv|
		    	file_last_line = IO.readlines("#{Rails.root}/profiles/linkedin-profile.xlsx", "a")
		    	csv << header unless file_last_line.first.present?
		    	csv.write "\n"
		    	csv << @profile.first_name
		    	csv << ","
		    	csv << @profile.last_name
		    	csv << ","
		    	csv << @profile.current_companies.first[:title]
		    	csv << ","
		    	csv << @profile.current_companies.first[:company]
		    	csv << ","
		    	csv << @profile.linkedin_url
		    	csv << ","
		    	csv << @profile.location
		    	csv << ","
		    	csv << city_state_country[1]
		    	csv << ","
		    	csv << @profile.country
		    end
		    flash[:success] = "Profile details has been added successfully"
		  	redirect_to new_scrapper_path
			end
		end
	end

	def download_excel
		send_file "#{Rails.root}/profiles/linkedin-profile.xlsx", :type => 'application/vnd.ms-excel; charset=utf-8'
		# send_file(File.new("#{Rails.root}/profiles/out.xlsx", :filename => "out.xlsx", :type =>  "application/vnd.ms-excel"))
	end
end
