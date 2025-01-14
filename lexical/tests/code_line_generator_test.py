# -*- coding: utf-8 -*-

from unittest import TestCase, skip
from lexical import code_line_generator
from types import GeneratorType
from tempfile import NamedTemporaryFile


class CodeLineGeneratorTest(TestCase):
    @skip('TODO')
    def test_unicode(self):
        code = '; Something\nCPY #$11'
        gen = code_line_generator(code)
        self.assertIsInstance(gen, GeneratorType)
        self.assertEqual('; Something\n', next(gen))
        self.assertEqual('CPY #$11', next(gen))
        with self.assertRaises(StopIteration):
            next(gen)

    @skip('TODO')
    def test_byte_string(self):
        code = 'CPX #$0A\n; Another\n; idea\n'
        gen = code_line_generator(code)
        self.assertIsInstance(gen, GeneratorType)
        self.assertEqual('CPX #$0A\n', next(gen))
        self.assertEqual('; Another\n', next(gen))
        self.assertEqual('; idea\n', next(gen))
        with self.assertRaises(StopIteration):
            next(gen)

    @skip('TODO')
    def test_real_file(self):
        with NamedTemporaryFile(mode='r+') as f:
            f.write('; this\nADC #$0A\n;test\n\n')
            f.seek(0)
            gen = code_line_generator(f)
            self.assertEqual('; this\n', next(gen))
            self.assertEqual('ADC #$0A\n', next(gen))
            self.assertEqual(';test\n', next(gen))
            self.assertEqual('\n', next(gen))
            with self.assertRaises(StopIteration):
                next(gen)
