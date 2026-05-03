from mage_ai.settings.repo import get_repo_path
from mage_ai.io.config import ConfigFileLoader
from mage_ai.io.bigquery import BigQuery
from pandas import DataFrame
import os

@data_exporter
def export_data_to_bigquery(df: DataFrame, **kwargs) -> None:
    project_id = os.getenv('GOOGLE_CLOUD_PROJECT_ID', 'cryptopipe-project')
    dataset_id = os.getenv('BIGQUERY_DATASET', 'cryptopipe_raw_data')
    table_name = os.getenv('BIGQUERY_TABLE_NAME', 'top_crypto_prices')
    table_id = f'{project_id}.{dataset_id}.{table_name}'
    config_path = os.path.join(get_repo_path(), 'io_config.yaml')
    
    # Force a fresh table creation
    BigQuery.with_config(ConfigFileLoader(config_path, 'default')).export(
        df,
        table_id,
        if_exists='replace', # This will drop the old "index-only" table and make a new one
    )