-- Custom snippets for Ruby/Rails development
local ls = require('luasnip')
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

-- Simple RSpec snippets
ls.add_snippets('ruby', {
  s('describe', {
    t('RSpec.describe '), i(1, 'ClassName'), t(' do'),
    t({ '', '  ' }), i(2),
    t({ '', 'end' }),
  }),

  s('context', {
    t('context "'), i(1, 'when something'), t('" do'),
    t({ '', '  ' }), i(2),
    t({ '', 'end' }),
  }),

  s('it', {
    t('it "'), i(1, 'does something'), t('" do'),
    t({ '', '  ' }), i(2),
    t({ '', 'end' }),
  }),

  s('expect', {
    t('expect('), i(1, 'actual'), t(').to '), i(2, 'eq(expected)'),
  }),

  s('let', {
    t('let(:'), i(1, 'variable'), t(') { '), i(2, 'value'), t(' }'),
  }),

  s('subject', {
    t('subject(:'), i(1, 'name'), t(') { '), i(2, 'described_class.new'), t(' }'),
  }),

  s('before', {
    t('before do'),
    t({ '', '  ' }), i(1),
    t({ '', 'end' }),
  }),
})

-- Simple Rails snippets
ls.add_snippets('ruby', {
  s('validates', {
    t('validates :'), i(1, 'attribute'), t(', '), i(2, 'presence: true'),
  }),

  s('belongs_to', {
    t('belongs_to :'), i(1, 'association'),
  }),

  s('has_many', {
    t('has_many :'), i(1, 'associations'),
  }),

  s('scope', {
    t('scope :'), i(1, 'name'), t(', -> { '), i(2, 'where(...)'), t(' }'),
  }),
})
return {}
