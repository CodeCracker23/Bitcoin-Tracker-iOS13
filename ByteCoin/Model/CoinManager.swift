import Foundation

protocol CoinManagerDelegate {
    func refreshPage(money: String, name: String)
    func didFailWithError(error: Error)
}

struct CoinManager {
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "B8C93A27-D329-4994-99E7-7B9CE8D5E4FA"
    
    
    //coinData = CoinData()
    
    var delegate: CoinManagerDelegate?
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    func getCoinPrice(for currency: String) {
        
        let urlString = "\(baseURL)/\(currency)?apikey=\(apiKey)"
        
        if let url = URL(string: urlString){
            let session  = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data,response,error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                //let dataAsString = String(data: data!, encoding: .utf8)
                if let safeData = data {
                    if let bitcoinPrice = self.parseJSON(safeData) {
                        let bitcoinPriceStr = String(format: "%f.2", bitcoinPrice)
                        
                            self.delegate?.refreshPage(money: bitcoinPriceStr, name: currency)
                        
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ data: Data) -> Double? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CoinData.self, from: data)
            let lastPrice = decodedData.rate
            return lastPrice
            
        } catch {
            print(error)
            return nil
        }
    }
    
    
}
