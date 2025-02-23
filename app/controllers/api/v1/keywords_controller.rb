class Api::V1::KeywordsController < Api::V1::ApiApplicationController
  before_action :authenticate_api_user!

  def index
    keywords = current_user.keywords.page(params[:page] || 1).per(params[:per_page] || 10)
    render json: {
      keywords: ActiveModelSerializers::SerializableResource.new(keywords, each_serializer: KeywordSerializer),
      meta: {
        current_page: keywords.current_page,
        total_pages: keywords.total_pages,
        total_count: keywords.total_count
      }
    }
  end

  # POST /api/v1/keywords/upload
  def upload
    file = params[:file]
    return render json: { error: 'No file uploaded' }, status: :unprocessable_entity if file.blank?

    csv_content = file.read
    keywords = CsvParser.parse(csv_content)
    processed_keywords = KeywordProcessor.process(keywords)
    processed_keywords.each do |keyword|
      current_user.keywords.find_or_create_by(name: keyword)
    end

    render json: { message: 'File uploaded successfully' }, status: :ok
  end

  def detail

  end

  # GET /api/v1/keywords/:id/results
  def search
    search_term = params[:q]
    keywords = Keyword.none.page(0)
    keywords = current_user.keywords.includes(:search_result).where("name ILIKE ?", "%#{search_term}%").order(created_at: :desc).page(params[:page] || 1).per(20) if search_term.present?

    render json: {
      keywords: ActiveModelSerializers::SerializableResource.new(keywords, each_serializer: KeywordSerializer),
      meta: {
        current_page: keywords&.current_page,
        total_pages: keywords&.total_pages,
        total_count: keywords&.total_count
      }
    }
  end
end
