import io
import pandas as pd
import requests

if 'data_loader' not in globals():
    from mage_ai.data_preparation.decorators import data_loader

@data_loader
def load_data_from_api(*args, **kwargs):
    # CoinGecko API for top 10 coins in USD
    url = 'https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=10&page=1&sparkline=false'
    
    response = requests.get(url)
    
    # Return the raw JSON as a DataFrame
    return pd.DataFrame(response.json())