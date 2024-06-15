json.data do
  json.items do
    json.array!(@plan_details) do |plan_detail|
      json.id plan_detail.id
      json.user do
        json.name plan_detail.plan.user.name
        json.image url_for(plan_detail.plan.user.profile_image)
      end
      json.address plan_detail.address
      json.latitude plan_detail.latitude
      json.longitude plan_detail.longitude
    end
  end
end