module ApplicationHelper
  def china_date(time)
    time.strftime("%y年 %m月%d日")
  end
end
