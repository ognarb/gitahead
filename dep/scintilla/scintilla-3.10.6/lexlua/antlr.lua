-- Copyright 2006-2019 Mitchell mitchell.att.foicica.com. See License.txt.
-- ANTLR LPeg lexer.

local lexer = require('lexer')
local token, word_match = lexer.token, lexer.word_match
local P, R, S = lpeg.P, lpeg.R, lpeg.S

local lex = lexer.new('antlr')

-- Whitespace.
lex:add_rule('whitespace', token(lexer.WHITESPACE, lexer.space^1))

-- Keywords.
lex:add_rule('keyword', token(lexer.KEYWORD, word_match[[
  abstract break case catch continue default do else extends final finally for
  if implements instanceof native new private protected public return static
  switch synchronized throw throws transient try volatile
  while package import header options tokens strictfp
  false null super this true
]]))

-- Types.
lex:add_rule('type', token(lexer.TYPE, word_match[[
  boolean byte char class double float int interface long short void
]]))

-- Functions.
lex:add_rule('func', token(lexer.FUNCTION, 'assert'))

-- Identifiers.
lex:add_rule('identifier', token(lexer.IDENTIFIER, lexer.word))

-- Comments.
local line_comment = '//' * lexer.nonnewline^0
local block_comment = '/*' * (lexer.any - '*/')^0 * P('*/')^-1
lex:add_rule('comment', token(lexer.COMMENT, line_comment + block_comment))

-- Actions.
lex:add_rule('action', token(lexer.OPERATOR, P('{')) *
                       token('action', (1 - P('}'))^0) *
                       token(lexer.OPERATOR, P('}'))^-1)
lex:add_style('action', lexer.STYLE_NOTHING)

-- Strings.
lex:add_rule('string', token(lexer.STRING, lexer.delimited_range("'", true)))

-- Operators.
lex:add_rule('operator', token(lexer.OPERATOR, S('$@:;|.=+*?~!^>-()[]{}')))

-- Fold points.
lex:add_fold_point(lexer.OPERATOR, ':', ';')
lex:add_fold_point(lexer.OPERATOR, '(', ')')
lex:add_fold_point(lexer.OPERATOR, '{', '}')
lex:add_fold_point(lexer.COMMENT, '/*', '*/')
lex:add_fold_point(lexer.COMMENT, '//', lexer.fold_line_comments('//'))

return lex
