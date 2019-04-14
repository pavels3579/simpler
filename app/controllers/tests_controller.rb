class TestsController < Simpler::Controller

  def index
    @time = Time.now

    headers('Content-Type', 'text/html')
    status 302
    render plain: 'simp'
  end

  def create; end

  def show; end

end
