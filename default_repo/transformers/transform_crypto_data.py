import pandas as pd

if 'transformer' not in globals():
    from mage_ai.data_preparation.decorators import transformer

@transformer
def transform(data, *args, **kwargs):
    # Select only the columns we need for our dashboard
    cols = ['id', 'symbol', 'name', 'current_price', 'market_cap', 'total_volume', 'last_updated']
    df = data[cols]
    
    # Convert last_updated to datetime
    df['last_updated'] = pd.to_datetime(df['last_updated'])
    
    # Add an ingestion timestamp (crucial for partitioning later!)
    df['ingested_at'] = pd.Timestamp.now()
    
    return df