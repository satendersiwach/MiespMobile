import 'dart:io';

import 'package:scanner/common/get_formatted_date.dart';
import 'package:scanner/pdf_generation/pdf_api.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

class PdfInvoiceApi {
  static Future<File> generate({required String TransId}) async {
    final pdf = Document();
    // OCRTModel ocrtModel =
    //     (await retrieveOCRTById(null, 'TransId = ?', [TransId]))[0];
    // List<CRT1> crt1List =
    //     await retrieveCRT1ById(null, 'TransId = ?', [TransId]);

    pdf.addPage(MultiPage(
      pageFormat: const PdfPageFormat(55 * (72 / 25.4), 1000, marginAll: 0),
      build: (context) => [
        Align(
          alignment: Alignment.center,
          child: Text('Hello'),
        ),
        SizedBox(height: 0.8 * PdfPageFormat.cm, child: Divider()),
        Align(
          alignment: Alignment.center,
          child: Padding(
              padding: const EdgeInsets.only(right: 8, bottom: 8),
              child: Text("Hi")),
        ),
        SizedBox(height: 0.8 * PdfPageFormat.cm, child: Divider()),
        // _ocrt(ocrtModel: ocrtModel),
        // _crt1(crt1List: crt1List),
      ],
    ));

    return PdfApi.saveDocument(
        name:
            'CashReceipt-${getFormattedDateAndTime(DateTime.now()).replaceAll('/', '-')}.pdf',
        pdf: pdf);
  }

// static Widget _header() {
//   return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
//     Text('${CompanyDetails.ocinModel?.CompanyName}',
//         textAlign: TextAlign.center),
//     Text('${CompanyDetails.ocinModel?.Address}', textAlign: TextAlign.center),
//     Text('${CompanyDetails.ocinModel?.Email}', textAlign: TextAlign.center),
//     Text('${CompanyDetails.ocinModel?.Telephone}',
//         textAlign: TextAlign.center),
//   ]);
// }
//
// static Widget _date() {
//   return Column(children: [
//     Text('Cash Receipt',
//         textAlign: TextAlign.center),
//     Text('Date : ${getFormattedDate(DateTime.now())}',
//         textAlign: TextAlign.center),
//     Text('Doc Num : 1', textAlign: TextAlign.center),
//   ]);
// }

// static Widget _ocrt({required OCRTModel ocrtModel}) {
//   return Container(
//       decoration: BoxDecoration(border: Border.all(width: 1)),
//       child: Padding(
//           padding: EdgeInsets.all(8),
//           child:
//               Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//             Row(children: [
//               Text('TransId : ',
//                   style:
//                       TextStyle(fontWeight: FontWeight.bold, fontSize: 10)),
//               Text('${ocrtModel.TransId}', style: TextStyle(fontSize: 10)),
//             ]),
//             Row(children: [
//               Text('Posting Date : ',
//                   style:
//                       TextStyle(fontWeight: FontWeight.bold, fontSize: 10)),
//               Text(getFormattedDate(ocrtModel.PostingDate),
//                   style: TextStyle(fontSize: 10)),
//             ]),
//             Row(children: [
//               Text('Customer Code : ',
//                   style:
//                       TextStyle(fontWeight: FontWeight.bold, fontSize: 10)),
//               Text('${ocrtModel.CardCode}', style: TextStyle(fontSize: 10)),
//             ]),
//             Row(children: [
//               Text('Doc Status : ',
//                   style:
//                       TextStyle(fontWeight: FontWeight.bold, fontSize: 10)),
//               Text(ocrtModel.DocStatus ?? '', style: TextStyle(fontSize: 10)),
//             ]),
//             // Row(
//             //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             //     children: [
//             //   Flexible(child:  Text('Customer Name : ',
//             //       style: TextStyle(fontWeight: FontWeight.bold,
//             //           fontSize: 10)),),
//             //   Flexible(child:  Text(
//             //       '${ocrtModel.CardName}',style: TextStyle(
//             //       fontSize: 10)
//             //   ),)
//             // ]),
//             Row(children: [
//               Text('Customer Name : ',
//                   style:
//                       TextStyle(fontWeight: FontWeight.bold, fontSize: 10)),
//               Text('${ocrtModel.CardName}', style: TextStyle(fontSize: 10)),
//             ]),
//             Row(children: [
//               Text('Amount : ',
//                   style:
//                       TextStyle(fontWeight: FontWeight.bold, fontSize: 10)),
//               Text(ocrtModel.Amount?.toStringAsFixed(2) ?? '',
//                   style: TextStyle(fontSize: 10)),
//             ]),
//             Row(children: [
//               Text('Person Name : ',
//                   style:
//                       TextStyle(fontWeight: FontWeight.bold, fontSize: 10)),
//               Text('${ocrtModel.ContactPersonName}',
//                   style: TextStyle(fontSize: 10)),
//             ]),
//             Row(children: [
//               Text('Mobile No. : ',
//                   style:
//                       TextStyle(fontWeight: FontWeight.bold, fontSize: 10)),
//               Text(ocrtModel.MobileNo ?? '', style: TextStyle(fontSize: 10)),
//             ]),
//             Row(children: [
//               Text('Currency : ',
//                   style:
//                       TextStyle(fontWeight: FontWeight.bold, fontSize: 10)),
//               Text('${ocrtModel.Currency}', style: TextStyle(fontSize: 10)),
//             ]),
//             Row(children: [
//               Text('Currency Rate. : ',
//                   style:
//                       TextStyle(fontWeight: FontWeight.bold, fontSize: 10)),
//               Text(ocrtModel.CurrRate?.toStringAsFixed(2) ?? '',
//                   style: TextStyle(fontSize: 10)),
//             ]),
//             Row(children: [
//               Text('Amount Type : ',
//                   style:
//                       TextStyle(fontWeight: FontWeight.bold, fontSize: 10)),
//               Text('${ocrtModel.DocType}', style: TextStyle(fontSize: 10)),
//             ]),
//             Row(children: [
//               Text('Add. info. : ',
//                   style:
//                       TextStyle(fontWeight: FontWeight.bold, fontSize: 10)),
//               Text(ocrtModel.Remarks ?? '', style: TextStyle(fontSize: 10)),
//             ]),
//             Row(children: [
//               Text('Additional Amount : ',
//                   style:
//                       TextStyle(fontWeight: FontWeight.bold, fontSize: 10)),
//               Text(ocrtModel.AdAmount?.toStringAsFixed(2) ?? '',
//                   style: TextStyle(fontSize: 10)),
//             ]),
//             Row(children: [
//               Text('Local Date. : ',
//                   style:
//                       TextStyle(fontWeight: FontWeight.bold, fontSize: 10)),
//               Text(ocrtModel.LocalDate ?? '', style: TextStyle(fontSize: 10)),
//             ])
//           ])));
// }
//
// static Widget _crt1({required List<CRT1> crt1List}) {
//   return Container(
//       decoration: BoxDecoration(border: Border.all(width: 1)),
//       child: Padding(
//           padding: const EdgeInsets.all(8),
//           child:
//               Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//             Text('Invoice Data',
//                 style: TextStyle(fontWeight: FontWeight.bold)),
//             SizedBox(height: 0.8 * PdfPageFormat.cm, child: Divider()),
//             ListView.builder(
//                 itemCount: crt1List.length,
//                 itemBuilder: (context, index) {
//                   CRT1 crt1 = crt1List[index];
//                   return Column(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(children: [
//                           Text('INTransId : ',
//                               style: TextStyle(
//                                   fontWeight: FontWeight.bold, fontSize: 10)),
//                           Spacer(),
//                           Text('${crt1.INTransId ?? ''}',
//                               style: TextStyle(fontSize: 10)),
//                         ]),
//                         Row(children: [
//                           Text('Invoice Date : ',
//                               style: TextStyle(
//                                   fontWeight: FontWeight.bold, fontSize: 10)),
//                           Spacer(),
//                           Text('${getFormattedDate(crt1.PostingDate)}',
//                               style: TextStyle(fontSize: 10)),
//                         ]),
//                         Row(children: [
//                           Text('Doc Total : ',
//                               style: TextStyle(
//                                   fontWeight: FontWeight.bold, fontSize: 10)),
//                           Spacer(),
//                           Text('${crt1.DocTotal?.toStringAsFixed(2) ?? ''}',
//                               style: TextStyle(fontSize: 10)),
//                         ]),
//                         Row(children: [
//                           Text('Payment : ',
//                               style: TextStyle(
//                                   fontWeight: FontWeight.bold, fontSize: 10)),
//                           Spacer(),
//                           Text('${crt1.Payment?.toStringAsFixed(2) ?? ''}',
//                               style: TextStyle(fontSize: 10)),
//                         ]),
//                         Row(children: [
//                           Text('Balance : ',
//                               style: TextStyle(
//                                   fontWeight: FontWeight.bold, fontSize: 10)),
//                           Spacer(),
//                           Text('${crt1.Balance?.toStringAsFixed(2) ?? ''}',
//                               style: TextStyle(fontSize: 10)),
//                         ]),
//                         Divider(
//                           thickness: 1.5,
//                           // color: Colors.grey
//                         )
//                       ]);
//                 }),
//           ])));
// }
}
