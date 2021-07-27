require "test_helper"

class JobsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @job = jobs(:one)
  end

  test "should get index" do
    get jobs_url
    assert_response :success
  end

  test "should get new" do
    get new_job_url
    assert_response :success
  end

  test "should create job" do
    assert_difference('Job.count') do
      post jobs_url, params: { job: { date: @job.date, quote_id: @job.quote_id, service_hour: @job.service_hour, status: @job.status, total_cost: @job.total_cost } }
    end

    assert_redirected_to job_url(Job.last)
  end

  test "should show job" do
    get job_url(@job)
    assert_response :success
  end

  test "should get edit" do
    get edit_job_url(@job)
    assert_response :success
  end

  test "should update job" do
    patch job_url(@job), params: { job: { date: @job.date, quote_id: @job.quote_id, service_hour: @job.service_hour, status: @job.status, total_cost: @job.total_cost } }
    assert_redirected_to job_url(@job)
  end

  test "should destroy job" do
    assert_difference('Job.count', -1) do
      delete job_url(@job)
    end

    assert_redirected_to jobs_url
  end
end
