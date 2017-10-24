class CpfValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    record.errors.add(:cpf) if value.present? && !CPF.valid?(value)
  end
end

