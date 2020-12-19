require 'csv'

CSV.generate do |csv|
  # 1行目にラベルを追加
  csv_column_labels = %w(名前 説明 買った人 参照用URL\
                         ポイント おすすめ度 最初に買った日時\
                         ジャンル1の名前 ジャンル2の名前\
                         ジャンル3の名前 ジャンル4の名前\
                         ジャンル5の名前)
  csv << csv_column_labels
  # 各アイテムのカラム値を追加
  current_user.feed.each do |item|
    # まずジャンル以外のカラムを追加
    csv_column_values = [
      item.name,
      item.description,
      item.user.name,
      item.reference,
      item.point,
      item.recommend_degrees,
      item.created_at.strftime("%Y/%m/%d(%a)")
    ]
    # ジャンルの数(number_of_genres)を特定
    # 初期値を4にしておき、nameが空のジャンルが見つかったらその配列番号に置き換える
    number_of_genres = 4
    item.genres.each_with_index do |ing, index|
      if ing.name.empty?
        number_of_genres = index
        break
      end
    end
    # ジャンルの数だけカラムを追加する
    i = 0
    while i <= number_of_genres
      csv_column_values.push(item.genres[i].name)
      i += 1
    end
    # 最終的なcsv_column_valuesをcsvのセルに追加
    csv << csv_column_values
  end
end