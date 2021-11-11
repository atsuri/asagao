# TODO: 授業内課題07-1
%w(代表 副代表 会計係 ユニフォーム係 ボール係 合宿係 試合係 入退部係 イベント係).each do |name|
    Duty.create(
        name: name
    )
end