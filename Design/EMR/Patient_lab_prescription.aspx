<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Patient_lab_prescription.aspx.cs" Inherits="Design_EMR_Patient_lab_prescription" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <%--<link href="../../Styles/PurchaseStyle.css" rel="stylesheet" type="text/css" />--%>
     <link href="../../Styles/framestyle.css" rel="stylesheet" />
    <%--<link href="../../Styles/grid24.css" rel="stylesheet" />--%>
    <title></title>
</head>
<body>
    <script  type="text/javascript" src="../../Scripts/Message.js"></script>
   <script  src="../../Scripts/jquery-1.7.1.min.js" type="text/javascript"></script>
        <script src="../../Scripts/jquery.extensions.js" type="text/javascript"></script>
            <script  src="../../Scripts/json2.js" type="text/javascript"></script>

          <script  type="text/javascript">
              var TID = "";
              $(document).ready(function () {
                  TID = '<%=ViewState["TID"] .ToString()%>';

                  bindEMRInv();
              });
              function ckhall() {
                  if ($("#chkheader").attr('checked')) {
                      $("#tblInvNumeric :checkbox").attr('checked', 'checked');
                  }
                  else {
                      $("#tblInvNumeric :checkbox").attr('checked', false);
                  }

              }
              function ckhallradio() {
                  if ($("#chkheaderradio").attr('checked')) {
                      $("#tblInvText :checkbox").attr('checked', 'checked');
                  }
                  else {
                      $("#tblInvText :checkbox").attr('checked', false);
                  }

              }
              function bindEMRInv() {
                  $.ajax({
                      type: "POST",
                      url: "Services/EMR.asmx/bindEMRInvItem",
                      data: '{TID:"' + TID + '"}',
                      dataType: "json",
                      contentType: "application/json;charset=UTF-8",
                      async: true,
                      success: function (response) {
                          EMRInv = jQuery.parseJSON(response.d);
                          if (EMRInv != null) {
                              if (EMRInv.length > 0) {
                                  var tableNumeric = "<table id='tblInvNumeric' style='width:100%;' cellspacing='0' rules='all' border='1'><tr id='trNumeric'><th class='GridViewHeaderStyle' style='width:20px;'><input id='chkheader' type='checkbox'  onclick='ckhall();' /></th> <th class='GridViewHeaderStyle' style='width:200px;'>Department Name</th><th class='GridViewHeaderStyle' style='width:400px;' scope='col'>Investigation </th><th class='GridViewHeaderStyle' style='width:80px;' scope='col'>Date</th><th class='GridViewHeaderStyle' style='width:60px;display:none' scope='col'>View</th> </tr><tbody>";
                                  var tableText = "<table id='tblInvText' style='width:100%;' cellspacing='0' rules='all' border='1'><tr id='trText'>  <th class='GridViewHeaderStyle' style='width:20px;'></th><input id='chkheaderradio' type='checkbox'  onclick='ckhallradio();' /></th><th class='GridViewHeaderStyle' style='width:200px;'>Department Name</th><th class='GridViewHeaderStyle' style='width:400px;' scope='col'>Investigation </th><th class='GridViewHeaderStyle' style='width:120px;' scope='col'>Date</th> <th class='GridViewHeaderStyle' style='width:60px;' scope='col'>Findings</th><th class='GridViewHeaderStyle' style='width:60px;display:none' scope='col'>View</th> </tr><tbody>";
                                  for (var i = 0; i < EMRInv.length; i++) {
                                      if (EMRInv[i].ReportType == "1") {
                                          var row = "<tr>";
                                          row += "<td class='GridViewLabItemStyle' style='width:20px;'><input type='checkbox' id='chkInvNumeric' onclick='chkNumeric(this);' " + ((EMRInv[i].IsEnter == 'true') ? 'checked' : '') + " ></input></td>";
                                          row += "<td class='GridViewLabItemStyle'  id='tdDeptNameNumeric' style='width:200px;'>" + EMRInv[i].DeptName + "</td>";
                                          row += "<td class='GridViewLabItemStyle' align='center' id='tdInvestigationNumeric' style='width:400px;'>" + EMRInv[i].Name + "</td>";
                                          row += "<td class='GridViewLabItemStyle' style='width:120px;' id='tdDateNumeric'>" + EMRInv[i].Date + "</td>";
                                          row += "<td class='GridViewLabItemStyle' align='center' id='imgviewNumeric' style='width:20px;display:none'><img alt='view' src='../../Images/view.gif' style='border: 0px solid #FFFFFF; text-align:center; cursor:pointer'  onclick='viewLabItemNumeric(this)' /> </td>";
                                          row += "<td class='GridViewLabItemStyle' id='tdTest_IDNumeric' style='width:20px;display:none'>" + EMRInv[i].Test_ID + "</td>";
                                          row += "<td class='GridViewLabItemStyle' id='tdInvestigationIDNumeric' style='width:20px;display:none'>" + EMRInv[i].InvestigationID + "</td>";
                                          row += "<td class='GridViewLabItemStyle' id='tdLabInvIPD_IDNumeric' style='width:20px;display:none'>" + EMRInv[i].LabInvestigationIPD_ID + "</td>";
                                          row += "</tr>";
                                          tableNumeric += row;
                                      }
                                      else if ((EMRInv[i].ReportType == "3") || (EMRInv[i].ReportType == "5")) {
                                          var row1 = "<tr>";
                                          row1 += "<td class='GridViewLabItemStyle' style='width:20px;'><input type='checkbox' id='chkInvText' onclick='chkText(this);' " + ((EMRInv[i].IsEnter == 'true') ? 'checked' : '') + " ></input></td>";
                                          row1 += "<td class='GridViewLabItemStyle'  id='tdDeptNameText' style='width:200px;'>" + EMRInv[i].DeptName + "</td>";
                                          row1 += "<td class='GridViewLabItemStyle' align='center' id='tdInvestigationText' style='width:400px;'>" + EMRInv[i].Name + "</td>";
                                          row1 += "<td class='GridViewLabItemStyle' style='width:120px;' id='tdDateText'>" + EMRInv[i].Date + "</td>";
                                          row1 += "<td class='GridViewLabItemStyle' align='center' id='tdRemarksText' style='width:200px;'><input type='text' id='txtRemarksText'  maxlength='100' style='width:200px;' onkeyup='return validateRemarks(this)'  value='" + (EMRInv[i].Remarks) + "' ></input></td>";
                                          row1 += "<td class='GridViewLabItemStyle' align='center' id='imgviewText' style='width:20px;display:none'><img alt='view' src='../../Images/view.gif' style='border: 0px solid #FFFFFF; text-align:center; cursor:pointer'  onclick='viewLabItemText(this)' /> </td>";
                                          row1 += "<td class='GridViewLabItemStyle' id='tdTest_IDText' style='width:20px;display:none'>" + EMRInv[i].Test_ID + "</td>";
                                          row1 += "<td class='GridViewLabItemStyle' id='tdInvestigationIDText' style='width:20px;display:none'>" + EMRInv[i].InvestigationID + "</td>";
                                          row1 += "<td class='GridViewLabItemStyle' id='tdLabInvIPD_IDText' style='width:20px;display:none'>" + EMRInv[i].LabInvestigationIPD_ID + "</td>";
                                          row1 += "</tr>";
                                          tableText += row1;
                                      }

                                  }
                                  tableNumeric += "</tbody></table>";
                                  tableText += "</tbody></table>";
                                  $("#EMRInvOutputNumeric").append(tableNumeric);
                                  $("#EMRInvOutputText").append(tableText);
                                  $("#btnSaveInv").show();
                                  if ($("#tblInvNumeric tr").length == "1")
                                      $("#EMRInvOutputNumeric").hide();
                                  if($("#tblInvText tr").length=="1")
                                      $("#EMRInvOutputText").hide();
                              }
                          }
                          else {
                              $("#EMRInvOutputNumeric,#EMRInvOutputText,#btnSaveInv").hide();
                              
                          }
                             
                          
                          
                      },
                      error: function (xhr, status) {
                          window.status = status + "\r\n" + xhr.responseText;
                      }
                  });
              }

              function chkNumeric(rowid) {

              }
              function chkText(rowid) {

              }

              function validateRemarks(rowid) {
                  var RemarksText = $(rowid).closest('tr').find('#txtRemarksText').text().length;
                  if (RemarksText > "10") {
                      $("#lblMsg").text('Max length exceed');
                      return false;
                  }
              }
              function viewLabItemNumeric(rowid) {
                  var Test_IDNumeric = $(rowid).closest('tr').find('#tdTest_IDNumeric').text();
                  var LabType="IPD";
                  var TestID = "";
                  $("#tblInvNumeric tr").each(function () {                      
                      if ($(this).closest("tr").find('#chkInvNumeric').is(':checked')) {
                           if (TestID == "")
                               TestID = $.trim($(this).closest("tr").find('#tdTest_IDNumeric').text());
                           else
                               TestID = TestID + "," + $.trim($(this).closest("tr").find('#tdTest_IDNumeric').text());
                       }
                   });
                   if (TestID != "")
                       window.open('../../Design/Lab/printLabReport.aspx?TestID=' + TestID + '&LabType='+LabType+' ');

              }
              function viewLabItemText(rowid) {
                  var Test_IDText = $(rowid).closest('tr').find('#tdTest_IDText').text();
                  var LabType = "IPD";
                  var TestID = "";
                  $("#tblInvText tr").each(function () {
                      if ($(this).closest("tr").find('#chkInvText').is(':checked')) {
                          if (TestID == "")
                              TestID = $.trim($(this).closest("tr").find('#tdTest_IDText').text());
                          else
                              TestID = TestID + "," + $.trim($(this).closest("tr").find('#tdTest_IDText').text());
                      }
                  });
                  if (TestID != "")
                      window.open('../../Design/Lab/printLabReport.aspx?TestID=' + TestID + '&LabType=' + LabType + ' ');

              }

              function saveInv() {
                  var PID = '<%=PID%>';
                  var InvNumeric = []; var InvText = [];
                  $("#tblInvNumeric tr").each(function () {
                      if ($(this).closest("tr").find('#chkInvNumeric').is(':checked')) {
                           InvNumeric.push({ "PatientID": encodeURIComponent(PID), "TransactionID": encodeURIComponent(TID), "Investigation_ID": encodeURIComponent($(this).closest("tr").find('#tdInvestigationIDNumeric').text()), "LabInvestigationIPD_ID": encodeURIComponent($(this).closest("tr").find('#tdLabInvIPD_IDNumeric').text()), "Remarks": "", "Test_ID": encodeURIComponent($(this).closest("tr").find('#tdTest_IDNumeric').text()) });
                      }
                  });
                 
                  $("#tblInvText tr").each(function () {
                      if ($(this).closest("tr").find('#chkInvText').is(':checked')) {
                           InvText.push({ "PatientID": encodeURIComponent(PID), "TransactionID": encodeURIComponent(TID), "Investigation_ID": encodeURIComponent($(this).closest("tr").find('#tdInvestigationIDText').text()), "LabInvestigationIPD_ID": encodeURIComponent($(this).closest("tr").find('#tdLabInvIPD_IDText').text()), "Remarks": encodeURIComponent($(this).closest("tr").find('#txtRemarksText').val()), "Test_ID": encodeURIComponent($(this).closest("tr").find('#tdTest_IDText').text()) });
                      }
                  });                
                  if ((InvNumeric != "") || (InvText != "")) {
                    
                      $.ajax({
                          type: "POST",
                          url: "Services/EMR.asmx/saveEMRInvItem",
                          data: JSON.stringify({ InvNumeric: InvNumeric, InvText: InvText }),
                          dataType: "json",
                          contentType: "application/json;charset=UTF-8",
                          async: true,
                          success: function (response) {
                              EMRInv = response.d;
                              if (EMRInv == "1") {
                                  $("#lblMsg").text('Record Saved Successfully');
                              }
                              else {
                                  $("#lblMsg").text('Error occurred, Please contact administrator');
                              }

                          },
                          error: function (xhr, status) {
                              window.status = status + "\r\n" + xhr.responseText;
                              $("#lblMsg").text('Error occurred, Please contact administrator');
                          }
                      });
                  }
              }
          </script>
    <form id="form1" runat="server">
        <ajax:ScriptManager ID="ScriptManager1" runat="server">
        </ajax:ScriptManager>
        <div id="Pbody_box_inventory">
            <div class="POuter_Box_Inventory" style="text-align: center;">
              
                    <b>Investigation Result</b>
                    <br />
                    <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" ClientIDMode="Static"></asp:Label>
                    <div id="div1" style="display:none" >
                    <asp:RadioButtonList ID="rbtType" runat="server" Font-Bold="True" Font-Size="Medium"
                        RepeatDirection="Horizontal" AutoPostBack="True">
                        <asp:ListItem Selected="True">IPD</asp:ListItem>
                        <asp:ListItem>OPD</asp:ListItem>
                    </asp:RadioButtonList></div>
               </div>
           
            
          
            <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">Investigation Details Numeric ( IPD )</div>
        <table  style="width: 100%;border-collapse:collapse" id="myTable">
                <tr >
                    <td colspan="4">
                         <div id="EMRInvOutputNumeric" style="max-height: 600px; overflow-x: auto;">
                        </div>
                        <br />                       
                    </td>
                </tr>
            </table>
    </div>
             <div class="POuter_Box_Inventory">
             <div class="Purchaseheader">Investigation Details Text ( IPD )</div>
        <table  style="width: 100%;border-collapse:collapse" id="Table1">
                <tr >
                    <td colspan="4">
                         <div id="EMRInvOutputText" style="max-height: 600px; overflow-x: auto;">
                        </div>
                        <br />                       
                    </td>
                </tr>
            </table>
    </div>
            <div class="POuter_Box_Inventory" style="text-align:center">
                <input type="button" style="display:none"  value="Save" id="btnSaveInv" class="ItDoseButton" onclick="saveInv()" />
                </div>
        </div>
   

    </form>
</body>
</html>
