//
//  OverViewVC.swift
//  Cart & Cook
//
//  Created by Development  on 16/06/2021.
//

import Foundation
import UIKit
import Charts
class OverViewVC: UIViewController, UITextFieldDelegate, UIDocumentInteractionControllerDelegate {
   
    @IBOutlet weak var pieChartView: ShadowView!
    @IBOutlet weak var expenseView: ShadowView!
    @IBOutlet weak var itemExpenseWidth: NSLayoutConstraint!
    @IBOutlet weak var dateTypeTF: UITextField!
    @IBOutlet weak var topDateLabel: UILabel!
    @IBOutlet weak var ccexpValLabel: UILabel!
    @IBOutlet weak var supplierExpValLabel: UILabel!
    @IBOutlet weak var totalExpValLabel: UILabel!
    @IBOutlet weak var soaEndTF: UITextField!
    @IBOutlet weak var soaStartDateTF: UITextField!
    @IBOutlet weak var cartandcookBtn: UIButton!{
        didSet{
            cartandcookBtn.tag = 0
        }
    }
    @IBOutlet weak var supplierBtn: UIButton!{
        didSet{
            supplierBtn.tag = 1
        }
    }
    
    @IBOutlet weak var itemWiseChartview: BarChartView!
    @IBOutlet weak var fullScreenPieChartView: PieChartView!{
        didSet{
            fullScreenPieChartView.drawEntryLabelsEnabled = false
            fullScreenPieChartView.legend.enabled = true
            fullScreenPieChartView.isUserInteractionEnabled = true
            fullScreenPieChartView.holeRadiusPercent = 0
            fullScreenPieChartView.frame.size = CGSize(width: 125, height: 150)
            fullScreenPieChartView.animate(xAxisDuration: 1)
            fullScreenPieChartView.animate(yAxisDuration: 1)
            fullScreenPieChartView.delegate = self
        }
       
    }
    let datePicker1 = UIDatePicker()
    let datePicker2 = UIDatePicker()
    @IBOutlet weak var expensechartView: BarChartView!{
        didSet{
//            expensechartView.legend.enabled = false
//            expensechartView.isUserInteractionEnabled = true
//            expensechartView.frame.size = CGSize(width: 125, height: 150)
//            expensechartView.animate(xAxisDuration: 1)
//            expensechartView.animate(yAxisDuration: 1)
            
        }
       
    }
    @IBOutlet weak var exportBtn: UIButton!{
        didSet{
            exportBtn.layer.cornerRadius = 10
            exportBtn.layer.borderWidth = 1
            exportBtn.layer.borderColor = UIColor.gray.cgColor
        }
    }
    
    var HTMLContent: String!
    let pathToSOACCHTMLTemplate =  Bundle.main.path(forResource: "SOACC", ofType: "html")
    let pathToSOACCLastItemHTMLTemplate =  Bundle.main.path(forResource: "SOACCLastItem", ofType: "html")
    let pathToSOASupplierHTMLTemplate =  Bundle.main.path(forResource: "SOASuplier", ofType: "html")
    let pathToSOASupplierLastItemHTMLTemplate =  Bundle.main.path(forResource: "SOASuplierLastItem", ofType: "html")
    
    let pickerView = ToolbarPickerView()
    let Menu = ["DAILY", "WEEKLY", "MONTHLY", "YEARLY"]
    var startDate = ""
    var endDate = ""
    var selectedIdex = 0
    var overViewVM = OverViewVM()
    var currentDate = Calendar.current.startOfDay(for: Date())
    let dateFormatter = DateFormatter()
    let cal = NSCalendar.current
    let ccColorList = [AppColor.chartGreen.value]
    let spColorList = [AppColor.chartRed.value]
    let productColorList = [AppColor.chartClr1.value]
    let colorList = [AppColor.chartClr1.value] + [AppColor.chartClr2.value] + [AppColor.chartClr3.value] + [AppColor.chartClr4.value] + [AppColor.chartClr5.value] + [AppColor.chartClr6.value] + [AppColor.chartClr7.value] + [AppColor.chartClr8.value] + [AppColor.chartClr9.value] + [AppColor.chartClr10.value] + [AppColor.chartClr11.value] + [AppColor.chartClr12.value] + [AppColor.chartClr13.value] + [AppColor.chartClr14.value] + [AppColor.chartClr15.value]
    var xValues: [String] = []
    var yValues: [Double] = []
    var yValues2: [Double] = []
    var productxValues: [String] = []
    var productyValues: [Double] = []
    
    override func viewDidLoad() {
        dateFormatter.dateFormat = "yyyy-MM-dd"
        setupDelegateForPickerView()
        setupDelegatesForTextFields()
        getDailyDateValues()
        showDatePicker()
    }
    
    @IBAction func backAction(_ sender: Any) {
        if let vc =  UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "HomeTabBarControllerViewController") as? HomeTabBarControllerViewController {
            vc.selectedIndex = 0
            self.navigationController?.pushViewController(vc, animated:   true)

        }
    }
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBAction func soaModeSelection(_ sender: UIButton) {
        if(sender.tag == 0) {
            selectedIdex = 0
            self.cartandcookBtn.setImage(UIImage(systemName: "circle.circle.fill"), for: .normal)
            self.supplierBtn.setImage(UIImage(systemName: "circle"), for: .normal)
            
        } else {
            selectedIdex = 1
            self.cartandcookBtn.setImage(UIImage(systemName: "circle"), for: .normal)
            self.supplierBtn.setImage(UIImage(systemName: "circle.circle.fill"), for: .normal)
        }
    }
    
    @IBAction func exportAction(_ sender: Any) {
        if(self.selectedIdex == 0) {
            if let vc =  UIStoryboard(name: "Menu", bundle: nil).instantiateViewController(withIdentifier: "CreadSOAPDF") as? CreadSOAPDF {
                let satrtDate = self.soaStartDateTF.text ?? ""
                let endDate = self.soaEndTF.text ?? ""
                let typ = self.dateTypeTF.text ?? ""
                vc.startDate = satrtDate
                vc.endDate = endDate
                vc.type = typ
                self.navigationController?.pushViewController(vc, animated:   true)
            }
        } else {
            if let vc =  UIStoryboard(name: "Menu", bundle: nil).instantiateViewController(withIdentifier: "CreateSOASupplierPDF") as? CreateSOASupplierPDF {
                let satrtDate = self.soaStartDateTF.text ?? ""
                let endDate = self.soaEndTF.text ?? ""
                let typ = self.dateTypeTF.text ?? ""
                vc.startDate = satrtDate
                vc.endDate = endDate
                vc.type = typ
                self.navigationController?.pushViewController(vc, animated:   true)
            }
        }
       
    }
    
    
    @IBAction func savePdf(_ sender: Any) {
//        let pdfData = NSMutableData()
//            UIGraphicsBeginPDFContextToData(pdfData, expensechartView.bounds, nil)
//            UIGraphicsBeginPDFPage()
//
//            guard let pdfContext = UIGraphicsGetCurrentContext() else { return }
//
//        expensechartView.layer.render(in: pdfContext)
//            UIGraphicsEndPDFContext()
//
//
//            if let documentDirectories = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first {
//                let documentsFileName = documentDirectories + "/" + "overview.pdf"
//                debugPrint(documentsFileName)
//                pdfData.write(toFile: documentsFileName, atomically: true)
//                let viewer = UIDocumentInteractionController(url: URL(fileURLWithPath: documentsFileName))
//                      viewer.delegate = self
//
//                      viewer.presentPreview(animated: true)
//            }
       
        
        let pdf = NSMutableData()
        UIGraphicsBeginPDFContextToData(pdf, CGRect(x: -60, y: 50, width: 595.2 , height: 841.8), nil);
            UIGraphicsBeginPDFPage();
        guard let context = UIGraphicsGetCurrentContext() else { return }
        let now = Date()
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "dd-MM-yyy hh:mm a"
        let headerText: NSString  = formatter.string(from: now) as NSString
        headerText.draw(at: CGPoint(x:400, y:-20), withAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12.0),  NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        
        
        
        
        let footerText: NSString = "Powered by Cart and Cook"
        
     
        let font = UIFont.systemFont(ofSize: 12.0)
        let attributes = [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: UIColor.lightGray]
        let pageNumber = "Page " + "- \(1) "
        var size = pageNumber.size(withAttributes: attributes)
        let drawX = 450
        let drawY = 595
        var drawPoint = CGPoint(x: drawX, y: drawY)
        
            pageNumber.draw(at: drawPoint, withAttributes: attributes)
       
        
            size = footerText.size(withAttributes: attributes)
//            drawX = footerRect.maxX - size.width - 80
            drawPoint = CGPoint(x: -50, y: 595 )
            footerText.draw(at: drawPoint, withAttributes: attributes)
        
        
        
        
        
   
        let views = [expenseView, pieChartView]
            for view in views {
                view?.layer.render(in: context)
                let height = view?.bounds.size.height ?? 0
                context.translateBy(x: 0, y: height + 30);
            }
 
            UIGraphicsEndPDFContext()
            if let documentDirectories = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first {
                let documentsFileName = documentDirectories + "/" + "overview.pdf"
                debugPrint(documentsFileName)
                pdf.write(toFile: documentsFileName, atomically: true)
                let viewer = UIDocumentInteractionController(url: URL(fileURLWithPath: documentsFileName))
                      viewer.delegate = self

                      viewer.presentPreview(animated: true)
            }
        
        
    }
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController
    {


        UINavigationBar.appearance().tintColor = UIColor.white

        return self
    }
    
    func showDatePicker(){
        datePicker1.datePickerMode = .date
        datePicker2.datePickerMode = .date
        if #available(iOS 13.4, *) {
            datePicker1.preferredDatePickerStyle = .wheels
            datePicker2.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        //ToolBar
       let toolbar1 = UIToolbar();
        toolbar1.sizeToFit()
          let doneButton1 = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker1));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
         let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));

        toolbar1.setItems([doneButton1,spaceButton,cancelButton], animated: false)

        soaEndTF.inputAccessoryView = toolbar1
        soaEndTF.inputView = datePicker2
        
        //ToolBar
       let toolbar = UIToolbar();
        toolbar.sizeToFit()
          let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));

        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)

          soaStartDateTF.inputAccessoryView = toolbar
        soaStartDateTF.inputView = datePicker1
        
        
       }
    
    
    @objc func donedatePicker(){

      let formatter = DateFormatter()
      formatter.dateFormat = "yyyy-MM-dd"
      soaStartDateTF.text = formatter.string(from: datePicker1.date)
      self.view.endEditing(true)
    }
    @objc func donedatePicker1(){

      let formatter = DateFormatter()
      formatter.dateFormat = "yyyy-MM-dd"
      soaEndTF.text = formatter.string(from: datePicker2.date)
      self.view.endEditing(true)
    }

    @objc func cancelDatePicker(){
       self.view.endEditing(true)
     }
   


    private func getOverView() {
        activityIndicator.startAnimating()
        let type = self.dateTypeTF.text ?? ""
        self.overViewVM.getOverView(startDate: self.startDate, endDate: self.endDate, type: type){
            isSuccess, errorMessage  in
            self.activityIndicator.stopAnimating()
            let ccexp =  self.overViewVM.responseStatus?.result?.expense?.ccExpense ?? 0.0
            self.ccexpValLabel.text = "AED " + "\(ccexp)"
            let suplierexp =  self.overViewVM.responseStatus?.result?.expense?.supplierExpense ?? 0.0
            self.supplierExpValLabel.text = "AED " + "\(suplierexp)"
            
            let totalerexp =  self.overViewVM.responseStatus?.result?.expense?.totalExpense ?? 0.0
            self.totalExpValLabel.text = "AED " + "\(totalerexp)"
            self.xValues = []
            self.yValues = []
            self.yValues2 = []
            if let charts = self.overViewVM.responseStatus?.result?.chartData {
//                print(charts)
                for chart in charts {
                    if let  xVal = chart.xValue {
                        
                        if(type.lowercased() == "weekly" ||  type.lowercased() == "daily") {
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "dd/MM/yyyy"
                            if let date = dateFormatter.date(from: xVal)  {
                                dateFormatter.dateFormat = "dd/MM"
                                let day = dateFormatter.string(from: date)
                                self.xValues.append(day)
                            }
                            
                            
                           
                        } else {
                            self.xValues.append(xVal)
                        }
                        
                       
                    }
                    if let  yVal1 = chart.ccValue {
                        self.yValues.append(yVal1)
                    }
                    if let  yVal2 = chart.supplierValue {
                        self.yValues2.append(yVal2)
                    }
                }
                print(self.yValues, self.yValues2)
                self.customizeChart(dataPoints: charts, values: self.yValues, values2: self.yValues2)
                self.setupExpenseChart()
                
            }
            if let products = self.overViewVM.responseStatus?.result?.expenseProduct {
                for product in products {
                    if let  xVal = product.productName {
                        
                        self.productxValues.append(xVal)
                    }
                    if let  yVal = product.prdctTotal {
                        self.productyValues.append(Double(yVal))
                    }
                }
                self.customizeItemWiseChart(dataPoints: products, values: self.productyValues)
                self.setupItemWiseChart()
                
            }
            if let types = self.overViewVM.responseStatus?.result?.expenseType {
                var values: [Double] = []
                for type in types {
                    if let val = type.percentage {
                       values.append(val)
                    }
                }
                self.customizePieChart(dataPoints: types, values: values)
            }
        }
    }
    private func setupItemWiseChart() {
        itemWiseChartview.delegate = self
        itemWiseChartview.scaleXEnabled = true
        
        itemWiseChartview.scaleYEnabled = false
        itemWiseChartview.highlightPerTapEnabled = true
        itemWiseChartview.dragEnabled = true
        itemWiseChartview.fitBars = true
        itemWiseChartview.drawValueAboveBarEnabled = true
        itemWiseChartview.animate(yAxisDuration: 1)
        itemWiseChartview.legend.enabled = false
        itemWiseChartview.legend.drawInside = true

           // Chart Offset
        itemWiseChartview.setExtraOffsets(left: 10, top: 0, right: 20, bottom: 50)
           
           // Animation
        itemWiseChartview.animate(yAxisDuration: 1.5 , easingOption: .easeOutBounce)

           // Setup X axis
           let xAxis = itemWiseChartview.xAxis
           xAxis.labelPosition = .bottom
           xAxis.drawAxisLineEnabled = true
           xAxis.drawGridLinesEnabled = false
           xAxis.granularityEnabled = false
           xAxis.labelRotationAngle = -50
        xAxis.valueFormatter = IndexAxisValueFormatter(values: self.productxValues)
           xAxis.axisLineColor = .black
           xAxis.labelTextColor = .black
           let rightAxis = itemWiseChartview.rightAxis
           rightAxis.enabled = false
    }
    
    private func setupExpenseChart() {
        
        expensechartView.delegate = self
        expensechartView.noDataText = "No Data Available."


      //legend
      let legend = expensechartView.legend
      legend.enabled = true
        legend.horizontalAlignment = .right
        legend.verticalAlignment = .top
        legend.orientation = .horizontal
      legend.drawInside = true
        legend.yOffset = 0.0;
        legend.xOffset = 0.0;
        legend.yEntrySpace = 0.0;

        
        
//        let legend = expensechartView.legend
//        Legend l1 = purchaseChart.getLegend();
//        l1.setVerticalAlignment(Legend.LegendVerticalAlignment.TOP);
//        l1.setHorizontalAlignment(Legend.LegendHorizontalAlignment.RIGHT);
//        l1.setOrientation(Legend.LegendOrientation.VERTICAL);
//        l1.setDrawInside(true);
//        l1.setYOffset(0f);
//        l1.setXOffset(10f);
//        l1.setYEntrySpace(0f);
//        l1.setTextSize(8f);
//
        

      let xaxis = expensechartView.xAxis
      xaxis.drawGridLinesEnabled = true
      xaxis.labelPosition = .bottom
      xaxis.centerAxisLabelsEnabled = true
      xaxis.valueFormatter = IndexAxisValueFormatter(values:self.xValues)
      xaxis.granularity = 1


      let leftAxisFormatter = NumberFormatter()
      leftAxisFormatter.maximumFractionDigits = 1

      let yaxis = expensechartView.leftAxis
      yaxis.spaceTop = 0.35
      yaxis.axisMinimum = 0
      yaxis.drawGridLinesEnabled = false
        yaxis.labelPosition = .outsideChart
        expensechartView.rightAxis.enabled = false
        

    }
    
    func customizeChart(dataPoints: [ChartDatum], values: [Double], values2: [Double]) {
        
        var dataEntries: [BarChartDataEntry] = []
               var dataEntries1: [BarChartDataEntry] = []
        var dataEntries2: [ChartDataEntry] = []
               for i in 0..<values.count {
                let date = dataPoints[i].xValue ?? ""
                  let ccval = dataPoints[i].ccValue ?? 0.0
                  let suplier = dataPoints[i].supplierValue ?? 0.0
                 let ccvalStr = "\n" + "C & C    :" + "\(ccval)"
                 let suplierStr  = "\n" + "Supplier :" + "\(suplier)"
                  let datastring = date + ccvalStr + suplierStr
      
//                        let dataEntry = BarChartDataEntry(x: Double(i), y: values[i], data: datastring)
//                        dataEntries.append(dataEntry)
              
                          let dataEntry1 = BarChartDataEntry(x: Double(i), y: values[i], data: datastring)
                          let dataEntry2 = BarChartDataEntry(x: Double(i), y: values2[i], data: datastring)
                          dataEntries.append(dataEntry1)
                          dataEntries2.append(dataEntry2)
                  

               }

        let barchartDataset1 = BarChartDataSet(entries: dataEntries, label: "C-C Expenses")
           let barchartDataset2 = BarChartDataSet(entries: dataEntries2, label:  "Supplier Expenses")
           let dataSets: [BarChartDataSet] = [barchartDataset1,barchartDataset2]
           barchartDataset1.colors = self.ccColorList
           barchartDataset2.colors = self.spColorList

               let chartData = BarChartData(dataSets: dataSets)


               let groupSpace = 0.3
               let barSpace = 0.05
               let barWidth = 0.3
               // (0.3 + 0.05) * 2 + 0.3 = 1.00 -> interval per "group"

               let groupCount = values.count
               let startYear = 0


               chartData.barWidth = barWidth;
               expensechartView.xAxis.axisMinimum = Double(startYear)
               let gg = chartData.groupWidth(groupSpace: groupSpace, barSpace: barSpace)
              
        expensechartView.xAxis.axisMaximum = Double(startYear) + gg * Double(groupCount)

               chartData.groupBars(fromX: Double(startYear), groupSpace: groupSpace, barSpace: barSpace)
               //chartData.groupWidth(groupSpace: groupSpace, barSpace: barSpace)
        expensechartView.notifyDataSetChanged()

        expensechartView.data = chartData






//               background color
//        expensechartView.backgroundColor = UIColor(red: 189/255, green: 195/255, blue: 199/255, alpha: 1)

               //chart animation
        expensechartView.animate(xAxisDuration: 1.5, yAxisDuration: 1.5, easingOption: .linear)

    }
    
    func customizeItemWiseChart(dataPoints: [ExpenseProduct], values: [Double]) {
      // TO-DO: customize the chart here
        // 1. Set ChartDataEntry
        var dataEntries: [ChartDataEntry] = []
        for i in 0..<dataPoints.count  {
            var type = dataPoints[i].productName ?? ""
            let typeTotal = dataPoints[i].prdctTotal ?? 0
            let percetage = dataPoints[i].percentage ?? 0.0
            type = type + ": " + "\(typeTotal)"
            let amount = dataPoints[i].amount ?? 0.0
           let amountStr = "\n" + "Amount    :" + "\(amount)"
           let percentStr  = "\n" + "Percentage :" + "\(percetage)" + "%"
            let datastring = type + amountStr + percentStr
            
          let dataEntry = BarChartDataEntry(x: Double(i), y: values[i], data: datastring)
          dataEntries.append(dataEntry)
        }
        // 2. Set ChartDataSet
        let barchartDataset = BarChartDataSet(entries: dataEntries, label: nil)
        barchartDataset.colors = self.productColorList
        let barChartData = BarChartData(dataSet: barchartDataset)
        let format = NumberFormatter()
        format.numberStyle = .none
        
        let formatter = DefaultValueFormatter(formatter: format)
        barChartData.setValueFormatter(formatter)
        barChartData.setValueTextColor(NSUIColor.clear)
        barChartData.barWidth = 0.5
        let fullWidth = CGFloat(0.5*Double(dataPoints.count))
        itemExpenseWidth.constant = max(fullWidth, view.frame.size.width)
        
        self.itemWiseChartview.data = barChartData
        itemWiseChartview.drawValueAboveBarEnabled = true
        let marker = ChartMarker()
        marker.chartView = self.expensechartView
        self.itemWiseChartview.marker = marker
        
        self.itemWiseChartview.data = barChartData
        self.itemWiseChartview.drawMarkers = true
    }
    
    func customizePieChart(dataPoints:[ExpenseType], values: [Double]) {
        var dataEntries: [ChartDataEntry] = []
        for i in 0..<dataPoints.count  {
            var type = dataPoints[i].type ?? ""
            let typeTotal = dataPoints[i].typeTotal ?? 0
            let percetage = dataPoints[i].percentage ?? 0.0
            type = type + ": " + "\(typeTotal)"
            let amount = dataPoints[i].amount ?? 0.0
           let amountStr = "\n" + "Amount    :" + "\(amount)"
           let percentStr  = "\n" + "Percentage :" + "\(percetage)" + "%"
            let datastring = type + amountStr + percentStr
            
            
            let dataEntry = PieChartDataEntry(value: values[i], label: dataPoints[i].type!, data: datastring)
          dataEntries.append(dataEntry)
        }
        // 2. Set ChartDataSet
        let pieChartDataSet = PieChartDataSet(entries: dataEntries, label: nil)
        pieChartDataSet.colors = self.colorList
        let pieChartData = PieChartData(dataSet: pieChartDataSet)
        let format = NumberFormatter()
        format.numberStyle = .none
        
        let formatter = DefaultValueFormatter(formatter: format)
        pieChartData.setValueFormatter(formatter)
        pieChartData.setValueTextColor(NSUIColor.clear)
        
        let marker = ChartMarker()
        marker.chartView = self.fullScreenPieChartView
        self.fullScreenPieChartView.marker = marker
        
        self.fullScreenPieChartView.data = pieChartData
        self.fullScreenPieChartView.drawMarkers = true
    }
    
    private func getDailyDateValues() {
       let seventhDatedate = cal.date(byAdding: Calendar.Component.day, value: -7, to: currentDate)!

       let dateFormatter = DateFormatter()
       dateFormatter.dateFormat = "yyyy-MM-dd"
        self.startDate  = dateFormatter.string(from: seventhDatedate)
        self.endDate = dateFormatter.string(from: currentDate)
        self.soaEndTF.text = self.endDate
        self.soaStartDateTF.text = self.startDate
        
        dateFormatter.dateFormat = "dd MMM"
        let start  = dateFormatter.string(from: seventhDatedate)
         let end = dateFormatter.string(from: currentDate)
         self.topDateLabel.text = start + " - " + end
        
        getOverView()
    }
    
    
    private func getWeeklyDateValues() {
        let firstDayComponents = cal.dateComponents([.year, .month], from: currentDate)
        let firstDay = cal.date(from: firstDayComponents)!

        let lastDayComponents = DateComponents(month: 1, day: -1)
        let lastDay = cal.date(byAdding: lastDayComponents, to: firstDay)!
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
         self.startDate  = dateFormatter.string(from: firstDay)
         self.endDate = dateFormatter.string(from: lastDay)
         self.soaEndTF.text = self.endDate
         self.soaStartDateTF.text = self.startDate
         
         dateFormatter.dateFormat = "dd MMM"
         let start  = dateFormatter.string(from: firstDay)
          let end = dateFormatter.string(from: lastDay)
          self.topDateLabel.text = start + " - " + end
         

        getOverView()
    }
    private func getMonthlyDateValues() {
        let year = Calendar.current.component(.year, from: Date())
        if let firstDay = Calendar.current.date(from: DateComponents(year: year , month: 1, day: 1)) {
            // Get the last day of the current year
            let firstOfNextYear = Calendar.current.date(from: DateComponents(year: year  + 1 , month: 1, day: 1))
            let lastDay = Calendar.current.date(byAdding: .day, value: -1, to: firstOfNextYear!)
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
             self.startDate  = dateFormatter.string(from: firstDay)
            self.endDate = dateFormatter.string(from: lastDay!)
             self.soaEndTF.text = self.endDate
             self.soaStartDateTF.text = self.startDate
             
             dateFormatter.dateFormat = "dd MMM"
             let start  = dateFormatter.string(from: firstDay)
            let end = dateFormatter.string(from: lastDay!)
              self.topDateLabel.text = start + " - " + end
        }
        
        getOverView()
    }
    private func getYearlyDateValues() {
        let year = Calendar.current.component(.year, from: Date())
        if let firstDay = Calendar.current.date(from: DateComponents(year: year - 5, month: 1, day: 1)) {
            // Get the last day of the current year
            let firstOfNextYear = Calendar.current.date(from: DateComponents(year: year  + 1 , month: 1, day: 1))
            let lastDay = Calendar.current.date(byAdding: .day, value: -1, to: firstOfNextYear!)
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
             self.startDate  = dateFormatter.string(from: firstDay)
            self.endDate = dateFormatter.string(from: lastDay!)
             self.soaEndTF.text = self.endDate
             self.soaStartDateTF.text = self.startDate
             
             dateFormatter.dateFormat = "dd MMM"
             let start  = dateFormatter.string(from: firstDay)
            let end = dateFormatter.string(from: lastDay!)
              self.topDateLabel.text = start + " - " + end
        }
        getOverView()
    }
    
    func setupDelegatesForTextFields() {
        dateTypeTF.delegate = self
        dateTypeTF.inputView = pickerView
        dateTypeTF.inputAccessoryView = pickerView.toolbar
        
    }

        func setupDelegateForPickerView() {
            pickerView.dataSource = self
            pickerView.delegate = self
            pickerView.toolbarDelegate = self
        }
    
    public   func createPDF(formatter: UIViewPrintFormatter, filename: String) -> String {
           let render = customSOAPrinter()
           render.addPrintFormatter(formatter, startingAtPageAt: 0)
           let page = CGRect(x: 0, y: 0, width: 595.2, height: 841.8) // A4, 72 dpi
           let printable = page.insetBy(dx: 0, dy: 0)
           
           render.setValue(NSValue(cgRect: page), forKey: "paperRect")
           render.setValue(NSValue(cgRect: printable), forKey: "printableRect")
           let pdfData = NSMutableData()
           UIGraphicsBeginPDFContextToData(pdfData, CGRect.zero, nil)
           
           for i in 1...render.numberOfPages {
               
               UIGraphicsBeginPDFPage();
               let bounds = UIGraphicsGetPDFContextBounds()
               render.drawPage(at: i - 1, in: bounds)
           }
           
           UIGraphicsEndPDFContext()
           let path = "\(NSTemporaryDirectory())\(filename).pdf"
           pdfData.write(toFile: path, atomically: true)
//           print("open \(path)")
           
           return path
       }
    
    func renderSOAInvoice(printDate: String,   items: [[String: Any]], totalAmount: Double,
                       subtotal: Double,
                       vat: Double) -> String! {
           
        var customerName = ""
        if let fname = UserDefaults.standard.value(forKey: FIRSTNAME) as? String {
          let lname = UserDefaults.standard.value(forKey: LASTNAME) as? String ?? ""
            customerName = fname + " " + lname
            
        }
         let num = UserDefaults.standard.value(forKey: PHONENUMBER) as? String  ?? ""
         
        var brand = UserDefaults.standard.value(forKey: BRAND) as? String ?? ""
        brand = "Brand :" + brand
        var rname = UserDefaults.standard.value(forKey: RESTAURANTNAME) as? String ?? ""
        var trn = UserDefaults.standard.value(forKey: TRNNUMBER) as? String ?? ""
        let email = UserDefaults.standard.value(forKey: EMAILID) as? String ?? ""
        trn = "TRN : " + trn
        rname = "Restaurant Name : " + rname
           do {
               var HTMLContent = try String(contentsOfFile: pathToSOACCHTMLTemplate!)
            HTMLContent = HTMLContent.replacingOccurrences(of: "#TAXNUMBER#", with: trn)
               HTMLContent =  HTMLContent.replacingOccurrences(of: "#PRINT DATE#", with: printDate)
               HTMLContent =  HTMLContent.replacingOccurrences(of: "#DELIVERYRNAME#", with: rname)
            HTMLContent =  HTMLContent.replacingOccurrences(of: "#DELIVERYBRANDNAME#", with: brand)
            HTMLContent =  HTMLContent.replacingOccurrences(of: "#CUSTOMERPHONE#", with: num)
            HTMLContent =  HTMLContent.replacingOccurrences(of: "#BRAND#", with: brand)
            HTMLContent =  HTMLContent.replacingOccurrences(of: "#OWNER#", with: customerName)
            HTMLContent =  HTMLContent.replacingOccurrences(of: "#EMAIL#", with: email)
            HTMLContent =  HTMLContent.replacingOccurrences(of: "#VAT AMOUNT#", with: "AED " + String(format: "%.2f", ceil(vat*100)/100))
            HTMLContent =  HTMLContent.replacingOccurrences(of: "#SUB TOTA#", with: "AED " + String(format: "%.2f", ceil(subtotal*100)/100))
            HTMLContent =  HTMLContent.replacingOccurrences(of: "#TOTAL AMOUNT#", with: "AED " + String(format: "%.2f", ceil(totalAmount*100)/100))

          var allItems = ""
          for i in 0..<items.count  {
              var itemHTMLContent: String!

                  itemHTMLContent = try String(contentsOfFile: pathToSOACCLastItemHTMLTemplate!)
            
            let singlePrice = items[i]["price"] as? Double ?? 0.0
            itemHTMLContent = itemHTMLContent.replacingOccurrences(of:"#DATE#", with: items[i]["date"] as? String ?? "")
            itemHTMLContent = itemHTMLContent.replacingOccurrences(of: "#INVOICENUMBER#", with:  items[i]["invoice"] as? String ?? "")
            itemHTMLContent = itemHTMLContent.replacingOccurrences(of: "#PAYMENTMODE#", with:  items[i]["paymnetMetgod"] as? String ?? "")
            itemHTMLContent = itemHTMLContent.replacingOccurrences(of: "#DESCRIPTION#", with: items[i]["description"] as? String ?? "")
            itemHTMLContent = itemHTMLContent.replacingOccurrences(of: "#PRICE#", with:String(format: "%.2f", ceil(singlePrice*100)/100) )

              allItems += itemHTMLContent
          }

                  // Set the items.
            HTMLContent = HTMLContent.replacingOccurrences(of: "#ITEMS#", with: allItems)

                  // The HTML code is ready.
                  return HTMLContent
           }
           
           catch {
               print("Unable to open and use HTML template files.")
           }

           return nil
    }
    func renderSOASupplierInvoice(printDate: String,   items: [[String: Any]], totalAmount: Double,
                       subtotal: Double,
                       vat: Double) -> String! {
           
        var customerName = ""
        if let fname = UserDefaults.standard.value(forKey: FIRSTNAME) as? String {
          let lname = UserDefaults.standard.value(forKey: LASTNAME) as? String ?? ""
            customerName = fname + " " + lname
            
        }
         let num = UserDefaults.standard.value(forKey: PHONENUMBER) as? String  ?? ""
         
        var brand = UserDefaults.standard.value(forKey: BRAND) as? String ?? ""
        brand = "Brand :" + brand
        var rname = UserDefaults.standard.value(forKey: RESTAURANTNAME) as? String ?? ""
        var trn = UserDefaults.standard.value(forKey: TRNNUMBER) as? String ?? ""
        let email = UserDefaults.standard.value(forKey: EMAILID) as? String ?? ""
        trn = "TRN : " + trn
        rname = "Restaurant Name : " + rname
           do {
               var HTMLContent = try String(contentsOfFile: pathToSOASupplierHTMLTemplate!)
            HTMLContent = HTMLContent.replacingOccurrences(of: "#TAXNUMBER#", with: trn)
               HTMLContent =  HTMLContent.replacingOccurrences(of: "#PRINT DATE#", with: printDate)
               HTMLContent =  HTMLContent.replacingOccurrences(of: "#DELIVERYRNAME#", with: rname)
            HTMLContent =  HTMLContent.replacingOccurrences(of: "#DELIVERYBRANDNAME#", with: brand)
            HTMLContent =  HTMLContent.replacingOccurrences(of: "#CUSTOMERPHONE#", with: num)
            HTMLContent =  HTMLContent.replacingOccurrences(of: "#BRAND#", with: brand)
            HTMLContent =  HTMLContent.replacingOccurrences(of: "#OWNER#", with: customerName)
            HTMLContent =  HTMLContent.replacingOccurrences(of: "#EMAIL#", with: email)
            HTMLContent =  HTMLContent.replacingOccurrences(of: "#VAT AMOUNT#", with: "AED " + String(format: "%.2f", ceil(vat*100)/100))
            HTMLContent =  HTMLContent.replacingOccurrences(of: "#SUB TOTA#", with: "AED " + String(format: "%.2f", ceil(subtotal*100)/100))
            HTMLContent =  HTMLContent.replacingOccurrences(of: "#TOTAL AMOUNT#", with: "AED " + String(format: "%.2f", ceil(totalAmount*100)/100))
            
          var allItems = ""
          for i in 0..<items.count  {
              var itemHTMLContent: String!

                  itemHTMLContent = try String(contentsOfFile: pathToSOASupplierLastItemHTMLTemplate!)
            
            let singlePrice = items[i]["price"] as? Double ?? 0.0
            itemHTMLContent = itemHTMLContent.replacingOccurrences(of:"#DATE#", with: items[i]["date"] as? String ?? "")
            itemHTMLContent = itemHTMLContent.replacingOccurrences(of: "#INVOICENUMBER#", with:  items[i]["invoice"] as? String ?? "")
            itemHTMLContent = itemHTMLContent.replacingOccurrences(of: "#PAYMENTMODE#", with:  items[i]["paymnetMetgod"] as? String ?? "")
            itemHTMLContent = itemHTMLContent.replacingOccurrences(of: "#DESCRIPTION#", with: items[i]["description"] as? String ?? "")
            itemHTMLContent = itemHTMLContent.replacingOccurrences(of: "#PRICE#", with:String(format: "%.2f", ceil(singlePrice*100)/100) )
                                                                    
            itemHTMLContent = itemHTMLContent.replacingOccurrences(of:"#SUPPLIER#", with: items[i]["supplier"] as? String ?? "")

              allItems += itemHTMLContent
          }

                  // Set the items.
            HTMLContent = HTMLContent.replacingOccurrences(of: "#ITEMS#", with: allItems)

                  // The HTML code is ready.
                  return HTMLContent
           }
           
           catch {
               print("Unable to open and use HTML template files.")
           }

           return nil
    }
    
}
extension OverViewVC : UIPickerViewDelegate, UIPickerViewDataSource {
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.Menu.count
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.Menu[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // Check if the textfield isFirstResponder.
        if dateTypeTF.isFirstResponder {
            dateTypeTF.text = self.Menu[row]
        }
        switch row {
        case 0:
            getDailyDateValues()
        case 1:
            getWeeklyDateValues()
        case 2:
            getMonthlyDateValues()
        case 3:
            getYearlyDateValues()
        default:
            getDailyDateValues()
        }
    }
    
}

extension OverViewVC: ToolbarPickerViewDelegate {

    func didTapDone() {
        self.view.endEditing(true)
    }

    func didTapCancel() {
       self.view.endEditing(true)
    }
}

extension OverViewVC: ChartViewDelegate
{
    public func chartValueSelected(_ expensechartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight)
    {
//        print("chartValueSelected : x = \(highlight.x)", highlight.dataIndex)
//        self.selectchartIndex = Int(highlight.x)
//        legentCV.reloadData()
    }
    
    public func chartValueNothingSelected(_ expensechartView: ChartViewBase)
    {
//        print("chartValueNothingSelected")
    }
}
