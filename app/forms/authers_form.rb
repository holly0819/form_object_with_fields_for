class AuthersForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  # attr_accessor :books_attrbbutesを記述することで、fields_forと連携される
  attr_accessor :id, :name, :sex, :auther, :books, :books_attributes

  def self.find(id)
    auther = Auther.find(id)
    books = auther.books
    # AuthersFormインスタンスにautherオブジェクトとbooksのオブジェクト群を入れる
    attr = auther.attributes.slice(*auther_attr).update(books: books, auther: auther)
    auther_form = AuthersForm.new(attr)
  end

  def books
    @books ||= [Book.new, Book.new]
  end
  
  def books_attributes=(attr)
    @books ||= []
    attr.each do |_n, params|
      @books << Book.new(params)
    end
  end

  def save
    # autherにbooksを加えて、saveを実行する
    @auther = Auther.new(auther_params)
    @auther.books << @books
    if @auther.save
      true
    else
      # 失敗したらエラーとともにfalseを返す
      errors_add
      false
    end
  end

  def update(params)
    debugger
    if  [auther.update(params.slice(*AuthersForm.auther_attr)), *books.map.with_index { |book, idx| book.update(params[:books_attributes][idx.to_s]) }].all?
      true
    else
      errors_add
      false
    end
  end
  
  
  def self.auther_attr
    # created_at, updated_at以外の全属性を返す
    Auther.attribute_names.delete_if { |attr| ['created_at', 'updated_at'].include?(attr) }
  end

  private

  def auther_params
    # AuthersFormのインスタンス変数をハッシュにして、キーから@を取り除き、Autherの項目のみを取り出す
    instance_variables.map{ |sym| [sym, instance_variable_get(sym)] }.to_h.transform_keys { |key| key.to_s[1..] }.slice(*AuthersForm.auther_attr)
  end

  def errors_add
    # autherとbooksに含まれるエラーをAuthersFormインスタンスに加える
    @auther.errors.each do |attr, msg|
      errors.add("Auther's #{attr}", msg)
    end
    @auther.books.each_with_index do |book, idx|
      book.errors.each do |attr, msg|
        errors.add("Book(#{idx + 1})'s #{attr}", msg)
      end
    end
  end
end