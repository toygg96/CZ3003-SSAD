import unittest
import load_testing


class TestSample(unittest.TestCase):

    # Check if query correct data from the database
    def test_get_valid_document_from_db(self):
        result = load_testing.get_from_db('student2')
        self.assertIsInstance(result, dict)
        self.assertTrue('overallScore' in result)
        self.assertTrue('character_class' in result)
        self.assertTrue('strength' in result)
        self.assertTrue('intelligence' in result)
        self.assertTrue('nickname' in result)

    # Check if invalid data is not returned from database
    def test_get_invalid_document_from_db(self):
        result = load_testing.get_from_db('samula')
        self.assertIsNone(result)

    # Check if insert is successful to database
    def test_set_document_from_db(self):
        document_name = "testing"
        value = {"walao": "hahhahahaahhaaha"}
        result = load_testing.insert_to_db(document_name, value)
        self.assertEqual(result, "Done inserting to db")

    # Check if delete is successful on database
    def test_delete_document_from_db(self):
        document_name = "testing"
        result = load_testing.delete_from_db(document_name)
        self.assertEqual(result, "Document deleted")


if __name__ == '__main__':
    unittest.main()
