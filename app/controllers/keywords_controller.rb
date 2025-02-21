class KeywordsController < ApplicationController
  before_action :set_keyword, only: [:show, :destroy]
  before_action :authenticate_user!

  def index
    @keywords = current_user.keywords
  end

  def new
    @keyword = Keyword.new
  end

  def create
    file = keyword_params[:file]
    if file.blank?
      return render json: { error: 'No file provided' }, status: :unprocessable_entity
    end

    csv_content = file.read
    keywords = CsvParser.parse(csv_content)
    processed_keywords = KeywordProcessor.process(keywords)

    processed_keywords.each do |keyword|
      current_user.keywords.find_or_create_by(name: keyword)
    end

    redirect_to keywords_url, notice: 'Keywords processed successfully.'
  rescue => e
    render :new
  end

  def show
  end

  def destroy
    @keyword.destroy
    respond_to do |format|
      format.html { redirect_to keywords_url, notice: 'Keyword was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def sample_csv
    sample_data = "Keywords\nWeather\nAmazon\nDefine"
    send_data sample_data, filename: "sample_keywords.csv", type: "text/csv"
  end

  private

  def set_keyword
    @keyword = Keyword.find(params[:id])
  end

  def keyword_params
    params.require(:keyword).permit(:file)
  end
end
