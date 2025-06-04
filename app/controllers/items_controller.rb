class ItemsController < ApplicationController
  def index
    items = Item.includes(:section)

    if params[:section_id].present? && params[:section_id] != 'all'
      items = items.where(section_id: params[:section_id])
    end

    q = items.ransack(params[:q])
    items = q.result(distinct: true).order(created_at: :desc)
    items = items.page(params[:page]).per(params[:per_page] || 10)

    render json: {
      items: items.map { |item| serialize_item(item) },
      pagination: {
        current_page: items.current_page,
        total_pages: items.total_pages,
        total_count: items.total_count,
        per_page: items.limit_value
      }
    }
  end

  def show
    item = Item.find(params[:id])

    render json: {
      id: item.id,
      name: item.name,
      description: item.description,
      image_url: item.image_url,
      section_name: item.section&.name,
      life_cycle: item.life_cycle,
      recycle_way: item.recycle_way,
      can_recycle: item.can_recycle,
      related_items: item.related_items.limit(5).map { |i| { id: i.id, name: i.name, image_url: i.image_url } },
      facilities: item.section.facilities.map do |f|
        {
          id: f.id,
          name: f.name,
          category: f.category,
          link: f.link
        }
      end
    }
  end

  private

  def serialize_item(item)
    {
      id: item.id,
      name: item.name,
      image_url: item.image_url,
    }
  end
end
