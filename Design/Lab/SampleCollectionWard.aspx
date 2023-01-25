<%@ Page Language="C#" AutoEventWireup="true" CodeFile="SampleCollectionWard.aspx.cs" Inherits="Design_Lab_SampleCollectionWard" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
       <%: System.Web.Optimization.Scripts.Render("~/bundle/folderinjs") %>
    <%: System.Web.Optimization.Styles.Render("~/bundle/folderincss") %>
    <script type="text/javascript" src="../../Scripts/shortcut.js"></script>
         <link rel="Stylesheet" href="../../Scripts/fancybox/jquery.fancybox-1.3.4.css" type="text/css" />
    <script type="text/javascript" src="../../Scripts/fancybox/jquery.fancybox-1.3.4.pack.js"></script>
    <script type="text/javascript" src="../../Scripts/fancybox/jquery.mousewheel-3.0.4.pack.js"></script>
    <form id="form1" runat="server">
       <div id="Pbody_box_inventory">
            <ajax:ScriptManager ID="sc" runat="server"></ajax:ScriptManager>
            <div class="POuter_Box_Inventory" style="text-align: center;">
                 <b>Sample Collection</b></div>
           <div class="POuter_Box_Inventory"  id="SearchFilteres">
            <div class="Purchaseheader">
                Search Option
             &nbsp;&nbsp;</div>
                <div class="row">
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-5"><label class="pull-left">Sample Status</label><b class="pull-right">:</b></div>
                        <div class="col-md-5"><select id="ddlSampleStatus" onchange="SearchPatientDetails();" >
                                <option value="N" selected="selected">Sample Not collected</option>
                                <option value="S">Collected</option>
                                <option value="Y">Received</option>
                                <option value="R">Rejected</option>
                            </select></div>
                    </div></div></div>
               <div class="row">
                        <div class="col-md-24">
                            <label  style="width:25px;height:25px;margin-left:5px;float:left;background-color:#ffff00;" class="circle"></label>
                            <b style="margin-top:5px;margin-left:5px;float:left">Sample Requested Time</b>
                            <label style= "width:25px;height:25px;margin-left:5px;float:left;background-color:DarkKhaki;" class="circle"></label>
                            <b style="margin-top:5px;margin-left:5px;float:left">Sample request expired</b>
                         <label style="width:25px;height:25px;margin-left:5px;float:left;background-color:orange;" class="circle"></label>
                            <b style="margin-top:5px;margin-left:5px;float:left">Upcoming requests next 15mins</b>
                        </div>
                        
                      
                    </div>
            </div>
                <div class="POuter_Box_Inventory">
                    <table width="99%">
                        <tr>
                            <td width="49%"  valign="top">
                                 <div class="Purchaseheader">Patient Detail
                                          <div style="text-align:right;position:relative;min-height:1px;padding-right:7.5px;padding-left: 7.5px;float: right;">
                   <span style="font-weight:bold;color:white;">Total Patient:</span>
              <asp:Label  ID="lblTotalPatient"  ForeColor="White" runat="server" CssClass="ItDoseLblError" />
                                              </div>

              </div>  
                                 <div style="width:100%;overflow:auto;">
                <table style="width:100%"  cellspacing="0" id="tb_ItemList" class="GridViewStyle">
                    <tr id="paheader">  
			<th class="GridViewHeaderStyle" scope="col" style="width:30px;" >S.No.</th>
                        
            <th class="GridViewHeaderStyle" scope="col" style="display:none" >View</th> 
           <td class="GridViewHeaderStyle" scope="col" style="width:25px">DOC</td>
            <th class="GridViewHeaderStyle" scope="col" >Patient Name</th>
			<th class="GridViewHeaderStyle" scope="col" style="display:none"  >Age</th>
            <th class="GridViewHeaderStyle" scope="col" style="display:none" >Date</th>
</tr>
                    </table>
                </div>
                            </td>
                            <td width="49%" valign="top">
                                  <div class="Purchaseheader" style="width:102.3%">Sample Detail
                                      <div style="text-align:right;position:relative;min-height:1px;padding-right:7.5px;padding-left: 7.5px;float: right;">
                   <span style="font-weight:bold;color:white;">Total Test:</span>
              <asp:Label ID="Label1" runat="server" ForeColor="White" CssClass="ItDoseLblError" />
<span id="spnledgerno" style="display:none"></span></div>

              </div>  
                                 <div>
                                     <div style="width:102.5%;max-height:300px;overflow:auto;">
                <table style="width:100%"  cellspacing="0" id="tbsample" class="GridViewStyle">
               <tr id="saheader">  
			   <th class="GridViewHeaderStyle" scope="col" style="width:20px;">S.No.</th>
			   <th class="GridViewHeaderStyle" scope="col" style="width:50px;">Sample Type</th>  
			   <th class="GridViewHeaderStyle" scope="col" style="width:50px;">Patient Name</th>
			   <th class="GridViewHeaderStyle" scope="col" style="width:50px;">Investigation</th>
               <th class="GridViewHeaderStyle" scope="col" style="width:50px;">Barcode No.<br /><input type="text" id="txtSINNo"  name="mybarocde" style="width:100px;display:none" placeholder="Barcode No." onkeyup="setbarcodetoall(this)" /></th>
                   <th class="GridViewHeaderStyle" scope="col" style="width:50px;">SC Withdraw Req Date</th>
                   <th class="GridViewHeaderStyle" scope="col" style="width:50px;">SC Actual Withdraw Date</th>
                   <th class="GridViewHeaderStyle" scope="col" style="width:50px;">Devation Time</th>
               <th class="GridViewHeaderStyle" scope="col" style="width:20px;"><input type="checkbox" onclick="call()" id="hd" /> </th>
                   <th class="GridViewHeaderStyle" scope="col" style="width:20px;">Vial Color</th>
			   <th class="GridViewHeaderStyle" scope="col" style="width:20px;">#</th>
               <th class="GridViewHeaderStyle" scope="col" style="width:20px;">Re-Print</th>
               <th class="GridViewHeaderStyle" scope="col" style="width:20px;">Reject</th>
</tr>
                    </table>
                                         
                                     </div>
           <div style="text-align:right;padding-right:3px;width:102.5%"><input type="button" value="Collect" id="btnsamplecollect" style="display:none"  onclick="SampleCollection()" /></div>
                </div>
                            </td>
                        </tr>
                    </table>

             
                    </div>  </div>
           <div id="RejectSample" class="modal fade">
	<div class="modal-dialog">
		<div class="modal-content" style="min-width: 500px;max-width:80%">
			<div class="modal-header">
				<button type="button" class="close"  onclick="$closeRejectSample()"   aria-hidden="true">&times;</button>
				<h4 class="modal-title">Reject Sample</h4>
                <span id="spnTestID" style="display:none"></span>
			</div>
			<div class="modal-body">
				 <div class="row">
					 <div  class="col-md-8">
						  <label class="pull-left"> Reject Reason    </label>
						  <b class="pull-right">:</b>
					 </div>
					 <div  class="col-md-15">
						  <input type="text" id="txtRejectReason"  />
					 </div>
					 				 </div>

				<div style="text-align:center" class="row">
					   <button type="button"  onclick="$rejectsample($('#txtRejectReason').val(),$('#spnTestID').text())">Reject</button>
				</div>
			</div>
			<div class="modal-footer">
			</div>
		</div>
	</div>
</div>
    <div id="DetailPopup" class="modal fade">
	<div class="modal-dialog">
		<div class="modal-content" style="min-width: 500px;max-width:80%">
			<div class="modal-header">
				<button type="button" class="close"  onclick="$closeDetailPopup()"   aria-hidden="true">&times;</button>
				<h4 class="modal-title">Sample Details</h4>
			</div>
			<div class="modal-body">
				 <div class="row">
					 <div  class="col-md-22">
						  <label class="pull-left">
                              <b><span id="spnname"></span></b></label>
					 </div>
					 				 </div>
                <div class="row">
                    <div  class="col-md-22">
						 <b> <span id="sampledate"></span></b>
					 </div>
                </div>
                <div class="row">
                    <div  class="col-md-22">
						 <b> <span id="spnReason"></span></b>
					 </div>
                </div>
			</div>
			<div class="modal-footer">
			</div>
		</div>
	</div>
</div>
        <div id="divSReqpatientServicePerModel" class="modal fade">
        <div class="modal-dialog">
            <div class="modal-content" style="width:50%">
                <div class="modal-header">
                    <b class="modal-title">
                        <label style= "margin-top:-10px;width:25px;height:25px;margin-left:5px;float:left;background-color:DarkKhaki;" class="circle"></label>
                            <b style="margin-top:-10px;margin-left:5px;float:left">Sample request expired</b>
                         <label style="margin-top:-10px;width:25px;height:25px;margin-left:5px;float:left;background-color:orange;" class="circle"></label>
                            <b style="margin-top:-10px;margin-left:5px;float:left">Upcoming requests next 15mins</b>
                        </b>
                    </div>
                <div class="modal-body">
                    <div class="row">
                         <div id="divList" style="max-height: 163px; max-width:643px; overflow-x: auto;">
                             <table class="FixedHeader" id="tbSRequestpatient" cellspacing="0" rules="all" border="1" style="width: 100%; border-collapse: collapse">
                                 <thead>
                                     <tr>
                                         <th class="GridViewHeaderStyle" style="width: 30px;">Sr No</th>
                                         <th class="GridViewHeaderStyle" style="width: 30px;">PatientName</th>
                                         <th class="GridViewHeaderStyle" style="width: 30px;">UHID</th>
                                     </tr>
                                     </thead>
                                 <tbody></tbody>
                                 </table>

                         </div>
                        </div>
                </div>
                <div class="modal-footer">
					<button type="button" onclick="closeSReqpatientServicePerModel()">Close</button>
                </div>
                </div>
            </div>
        </div>
        <script type="text/javascript">
            function showme(Name, Detail, reason) {
                if (reason != "") {
                    $('#spnReason').text('Sample Reject Reason : ' + reason);
                }
                $('#spnname').text('Name of Person : ' + Name);
                $('#sampledate').text('Date & Time : ' + Detail);
                $('#DetailPopup').showModel();
            }
            $closeDetailPopup = function () {
                $('#spnReason').text('');
                $('#spnname').text('');
                $('#sampledate').text('');
                $('#DetailPopup').hideModel();
            }
            function $rejectsample(RejectReason, TestID) {
                
                if (TestID == "") {
                    modelAlert("Kindly Refresh The Page");
                    return;
                }
                if (RejectReason == "") {
                    modelAlert("Please Enter The Reject Reason");
                    return;
                }
                serverCall('../Lab/SampleCollectionLab.aspx/SampleRejection', { RejectReason: RejectReason, TestID: TestID }, function (response) {
                    if (response == "1") {
                        $closeRejectSample();
                        modelAlert("Sample Reject Successfully", function () { SearchPatientDetails(); });
                        SearchPatientDetails();
                        return;
                    }
                    else {
                        $closeRejectSample();
                        modelAlert(response);
                        return;
                    }
                });
            }
            function $showRejectSample(TestID) {
                $('#spnTestID').text(TestID);
                $('#RejectSample').showModel();
            }

            $closeRejectSample = function () {
                $('#txtRejectReason').val('');
                $('#spnTestID').text('');
                $('#RejectSample').hideModel();
            }
            function SearchPatientDetails() {
                $('#tb_ItemList tr').slice(1).remove();
                $('#tbsample tr').slice(1).remove();
                pcount = 0;
                var searchdata = getsearchdata();
                serverCall('SampleCollectionWard.aspx/SearchSampleCollection', { searchdata: searchdata }, function (response) {
                    if (response != "") {
                        TestData = JSON.parse(response);
                        if (TestData.length == 0) {
                            $('#<%=lblTotalPatient.ClientID%>').html('0');
                            $('#<%=Label1.ClientID%>').html('0');
                            modelAlert("No Record Found");
                            return;
                        }
                        else {
                            $('#tb_ItemList tr').slice(1).remove();
                            for (var i = 0; i <= TestData.length - 1; i++) {
                                pcount = parseInt(pcount) + 1;
                                $('#<%=lblTotalPatient.ClientID%>').text(pcount);
                                var mydata = "<tr id='" + TestData[i].LedgerTransactionNo + "'  style='background-color:" + TestData[i].rowcolour + ";cursor:pointer' onclick='showbarcodedata(\"" + TestData[i].LedgerTransactionNo + "\")' >";
                                mydata += '<td class="GridViewLabItemStyle" style="' + (TestData[i].SReColorcode == '1' ? 'background-color: yellow;' : TestData[i].SReColorcode == '2' ? 'background-color: orange;' : TestData[i].SReColorcode == '3' ? 'background-color: DarkKhaki;' : '') + '">' + parseInt(i + 1) + '</td>';
                                mydata += '<td class="GridViewLabItemStyle"><img src="../../Images/attachment.png" style="cursor:pointer;" ';
                                mydata += 'onclick="openpopup6(\'' + TestData[i].LedgerTransactionNo + '\')"/></td>';
                                mydata += '<td class="GridViewLabItemStyle"><b>' + TestData[i].PName + '</b></td>';
                                mydata += '<td class="GridViewLabItemStyle" style="display:none"><b>' + TestData[i].PatientID + '</b></td>';
                                mydata += '<td class="GridViewLabItemStyle" style="display:none"><b>' + TestData[i].Age + '</b></td>';
                                mydata += '<td class="GridViewLabItemStyle" style="display:none">' + TestData[i].BillDate + '</td>';
                                mydata += "</tr>";
                                $('#tb_ItemList').append(mydata);
                                MarcTooltips.add('[data-title]', '', { position: 'up', align: 'left', mouseover: true });
                            }

                            checkSReqpatient();
                        }
                    }
                    else { modelAlert("No Record Found"); }
                });
            }
            function checkSReqpatient() {

                serverCall('SampleCollectionLab.aspx/searchSReqPatient', { fromDate: new Date().format("yyyy-MM-dd"), toDate: new Date().format("yyyy-MM-dd") }, function (response) {
                    var responseData = JSON.parse(response);
                    if (responseData != "") {
                        $('#divSReqpatientServicePerModel').showModel();
                        $('#tbSRequestpatient tbody ').empty();
                        if (responseData.length > 0) {
                            for (var i = 0; i < responseData.length; i++) {
                                var j = $('#tbSRequestpatient tbody tr').length + 1;
                                var row = "<tr id='" + responseData[i].LedgerTransactionNo + "' onclick='showbarcodedata(\"" + responseData[i].LedgerTransactionNo + "\")'>";
                                row += '<td class="GridViewLabItemStyle" style="text-align: center;' + (responseData[i].colorid != '1' ? 'background-color: DarkKhaki;' : 'background-color: orange;') + '">' + j + '</td>';

                                row += '<td id="tdSReqpatientname" class="GridViewLabItemStyle" style="text-align: center;' + (responseData[i].colorid != '1' ? 'background-color: DarkKhaki;' : 'background-color: orange;') + '">' + responseData[i].Pname + '</td>';
                                row += '<td id="tdSReqpatientuhid" class="GridViewLabItemStyle" style="text-align: center;' + (responseData[i].colorid != '1' ? 'background-color: DarkKhaki;' : 'background-color: orange;') + '">' + responseData[i].PatientID + '</td>';
                                row += '</tr>'
                                $('#tbSRequestpatient tbody').append(row);
                            }
                        }

                    }

                });
            }
            var closeSReqpatientServicePerModel = function () {
                $('#divSReqpatientServicePerModel').closeModel();
            }
            function openpopup6(LedgerTransactionNo) {
                var href = "../Lab/AddAttachment.aspx?LedgerTransactionNo=" + LedgerTransactionNo;
                $.fancybox({
                    maxWidth: 860,
                    maxHeight: 800,
                    fitToView: false,
                    width: '80%',
                    height: '70%',
                    href: href,
                    autoSize: false,
                    closeClick: false,
                    openEffect: 'none',
                    closeEffect: 'none',
                    'type': 'iframe'
                });
            }
            function getsearchdata() {
                var dataPLO = new Array();
                dataPLO[0] = '<%=ViewState["TID"].ToString()%>';
                dataPLO[1] = $('#ddlSampleStatus').val();
                return dataPLO;
            }
            var samplecount = 0;
            function showbarcodedata(LedgerTransactionNo) {
                $('#divSReqpatientServicePerModel').closeModel();
                $('#tbsample tr').slice(1).remove();
                samplecount = 0;
                serverCall('SampleCollectionLab.aspx/SearchInvestigation', { LedgerTransactionNo: LedgerTransactionNo }, function (response) {

                    if (response != "") {
                        TestData1 = JSON.parse(response);
                        if (TestData1.length == 0) {
                            $('#<%=Label1.ClientID%>').html('0');
                            samplecount = 0;
                            return;
                        }
                        else {
                            $('#spnledgerno').text('');
                            $('#spnledgerno').text(TestData[0].LedgerTransactionNo);
                            for (var i = 0; i <= TestData1.length - 1; i++) {
                                samplecount = parseInt(samplecount) + 1;
                                $('#<%=Label1.ClientID%>').text(samplecount);
                              var mydata = "<tr id='" + TestData1[i].TestID + "'  style='background-color:" + TestData1[i].rowcolor + ";'>";
                              mydata += '<td class="GridViewLabItemStyle">' + parseInt(i + 1) + '</td>';
                              mydata += '<td class="GridViewLabItemStyle">';
                              if (TestData1[i].IsSampleCollected == "N") {
                                  if (TestData1[i].reporttype == "7") {
                                      mydata += '<select id="ddlDoctorPath" style="width:140px;background-color:lightgreen;"">';
                                      if (TestData1[i].doctorlist.split('$').length > 1) {
                                          mydata += '<option value="0"></option>';
                                      }
                                      for (var c = 0; c <= TestData1[i].doctorlist.split('$').length - 1; c++) {

                                          mydata += '<option value="' + TestData1[i].doctorlist.split('$')[c].split('|')[0] + '">' + TestData1[i].doctorlist.split('$')[c].split('|')[1] + '</option>';
                                      }
                                      mydata += '</select><br>';

                                      if (TestData1[i].SampleID.length > 0) {
                                          mydata += '<input id="txtspecimentype" onkeypress="return blockSpecialChar(event)"  value="' + TestData1[i].SampleID.split('|')[0].split('^')[1] + '" type="text" placeholder="Enter Specimen Type" style="width:140px;background-color:lightblue;"/>';
                                      }
                                      else
                                          mydata += '<input id="txtspecimentype" onkeypress="return blockSpecialChar(event)" value=""  type="text" placeholder="Enter Specimen Type" style="width:140px;background-color:lightblue;"/>';
                                      mydata += '<br/><strong>No of Container:</strong>&nbsp;&nbsp;<select id="ddlnoofsp"><option>0</option>';
                                      mydata += '<option>1</option><option>2</option><option>3</option><option>4</option><option>5</option>';
                                      mydata += '<option>6</option><option>7</option><option>8</option><option>9</option></select>';

                                      mydata += '<br/><strong>No of Slides:</strong>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<select id="ddlnoofsli">';
                                      mydata += '<option>0</option><option>1</option><option>2</option><option>3</option><option>4</option><option>5</option>';
                                      mydata += '<option>6</option><option>7</option><option>8</option><option>9</option></select>';

                                      mydata += '<br/><strong>No of Block:</strong>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<select id="ddlnoofblock">';
                                      mydata += '<option>0</option><option>1</option><option>2</option><option>3</option><option>4</option><option>5</option>';
                                      mydata += '<option>6</option><option>7</option><option>8</option><option>9</option></select>';
                                      mydata += '<span id="tdss" style="display:none">' + TestData1[i].SampleID.split('|')[0].split('^')[0] + '</span>';
                                  }
                                  else {
                                      mydata += '<select id="sampletypes" style="width:140px;background-color:pink;" onchange="setclass(this)">';
                                      if (TestData1[i].SampleTypes.split('$').length > 1) {
                                          mydata += '<option value="0"></option>';
                                      }
                                      for (var c = 0; c <= TestData1[i].SampleTypes.split('$').length - 1; c++) {
                                          if (TestData1[i].SampleID.split('^')[0] == TestData1[i].SampleTypes.split('$')[c].split('|')[0])
                                              mydata += '<option selected="selected" value="' + TestData1[i].SampleTypes.split('$')[c].split('|')[0] + '">' + TestData1[i].SampleTypes.split('$')[c].split('|')[1] + '</option>';
                                          else
                                              mydata += '<option value="' + TestData1[i].SampleTypes.split('$')[c].split('|')[0] + '">' + TestData1[i].SampleTypes.split('$')[c].split('|')[1] + '</option>';
                                      }
                                      mydata += '</select>';
                                      mydata += '<span id="tdss" style="display:none">' + TestData1[i].SampleID.split('|')[0].split('^')[0] + '</span>';
                                  }
                              }
                                //else
                                //mydata += '<span id="tdss">' + TestData1[i].SampleID.split('|')[1] + '</span>';
                              mydata += '</td>';
                              mydata += '<td class="GridViewLabItemStyle"><b>' + TestData1[i].PName + '</b></td>';
                              mydata += '<td class="GridViewLabItemStyle"><b>' + TestData1[i].name + '</b></td>';
                              mydata += '<td class="GridViewLabItemStyle" >';
                              if (TestData1[i].IsSampleCollected == "N") {
                                  if (TestData1[i].PrePrintedBarcode == "1") {
                                      mydata += '<input type="textbox" name="mybarocde" onkeyup="samebarcode(this)" id="tdsinno" ';
                                      if (TestData1[i].SampleTypes.split('$').length > 1) {
                                          mydata += 'class="sample_0" ';
                                      }
                                      else {
                                          mydata += 'class="sample_' + TestData1[i].SampleTypes.split('|')[0] + '" ';
                                      }
                                      mydata += 'placeholder="Barcode No." style="width:100px;"/>';
                                  }
                                  else {
                                      mydata += '<span id="tdsinno" name="mybarocde" onkeyup="samebarcode(this)" ';
                                      if (TestData1[i].SampleTypes.split('$').length > 1) {
                                          mydata += 'class="sample_0" ';
                                      }
                                      else {
                                          mydata += 'class="sample_' + TestData1[i].SampleTypes.split('|')[0] + '" ';
                                      }
                                      mydata += '>' + TestData1[i].BarcodeNo + '</span> ';
                                  }
                              }
                              else {

                                  mydata += '<span id="tdsinno" name="mybarocde" onkeyup="samebarcode(this)" ';
                                  if (TestData1[i].SampleTypes.split('$').length > 1) {
                                      mydata += 'class="sample_0" ';
                                  }
                                  else {
                                      mydata += 'class="sample_' + TestData1[i].SampleTypes.split('|')[0] + '" ';
                                  }
                                  mydata += '>' + TestData1[i].BarcodeNo + '</span> ';
                              }

                                mydata += '</td>';
                                mydata += '<td class="GridViewLabItemStyle" style="font-size:x-small"><b><span id="spnScRequestdatetime">' + TestData1[i].Samplerequestdate + '</span></b></td>';
                                mydata += '<td class="GridViewLabItemStyle" style="font-size:x-small" ><b><span id="spnScRequestdate"> ' + TestData1[i].Acutalwithdrawdate + '</span></b></td>';
                                mydata += '<td class="GridViewLabItemStyle" style="font-size:x-small"><b>' + TestData1[i].DevationTime + '</b></td>';
                              mydata += '<td class="GridViewLabItemStyle" id="con" style="display:none;">' + TestData1[i].IsSampleCollected + '</td>';
                              mydata += '<td class="GridViewLabItemStyle"> ';
                              if (TestData1[i].IsSampleCollected == "N" || TestData1[i].IsSampleCollected == "S" || TestData1[i].IsSampleCollected == "R") {
                                  mydata += '<input type="checkbox" ';
                                  if (TestData1[i].IsSampleCollected == "N") {
                                      mydata += 'checked="checked" ';
                                  }
                                  else
                                      mydata += 'disabled="disabled" ';
                                  mydata += ' id="mmchk"/>';
                              }
                              mydata += '</td>';
                              if (TestData1[i].colorcode.split('^')[1] != "")
                                  mydata += '<td class="GridViewLabItemStyle" style="text-align:center;"><span style="cursor:pointer;color:white;background-color:' + TestData1[i].colorcode.split('^')[1] + ';font-size:15px;padding-left:5px;padding-right:5px;border-radius:150px;" data-title="Vial Color">' + TestData1[i].colorcode.split('^')[0] + '</span></td>';
                              else
                                  mydata += '<td class="GridViewLabItemStyle" style="text-align:center;"><span style="cursor:pointer;color:white;background-color:green;font-size:15px;padding-left:5px;padding-right:5px;border-radius:150px;fore-color:red" data-title="Vial Color">' + TestData1[i].colorcode.split('^')[0] + '</span></td>';
                              mydata += '<td class="GridViewLabItemStyle" style="text-align:center;" id="mmtd"> ';

                              if (TestData1[i].IsSampleCollected == "N") {
                                  mydata += '';
                              }
                              else if (TestData1[i].IsSampleCollected == "S") {
                                  mydata += '<span style="cursor:pointer; color:white;background-color:green;font-size:25px;padding-left:8px;padding-right:8px;border-radius:20px;" onclick="showme(\'' + TestData1[i].SampleCollector + '\',\'' + TestData1[i].colldate + '\',\'' + TestData1[i].rejectreason + '\')">C</span>';
                              }
                              else if (TestData1[i].IsSampleCollected == "Y") {
                                  mydata += '<span style="cursor:pointer;color:white;background-color:blue;font-size:25px;padding-left:8px;padding-right:8px;border-radius:20px;" onclick="showme(\'' + TestData1[i].SampleReceiver + '\',\'' + TestData1[i].recdate + '\',\'' + TestData1[i].rejectreason + '\')" >Y</span>';
                              }
                              else if (TestData1[i].IsSampleCollected == "R") {
                                  mydata += '<span style="cursor:pointer;color:white;background-color:red;font-size:25px;padding-left:8px;padding-right:8px;border-radius:20px;" onclick="showme(\'' + TestData1[i].rejectedBy + '\',\'' + TestData1[i].rejectdate + '\',\'' + TestData1[i].rejectreason + '\')" >R</span>';
                              }
                              mydata += '</td>';
                              mydata += '<td class="GridViewLabItemStyle" style="text-align:center;"> ';
                                if (TestData1[i].IsSampleCollected != "N" && TestData1[i].IsSampleCollected != "R") {
                                    mydata += '<img src="../../Images/print.gif" style="cursor:pointer" onclick="getBarcodeDetail(\'' + TestData1[i].BarcodeNoB +"#"+"B"+ '\',\'' + TestData1[i].Investigation_ID + '\')" />';
                                }
                              mydata += '</td>';
                              mydata += '<td class="GridViewLabItemStyle" style="text-align:center;"> ';
                              if (TestData1[i].IsSampleCollected != "N" && TestData1[i].IsSampleCollected != "R" && TestData1[i].Result_Flag == "0") {
                                  mydata += '<span title="Click To Reject Sample" style="cursor:pointer;color:white;background-color:red;font-size:15px;padding-left:5px;padding-right:5px;border-radius:150px;" onclick="$showRejectSample(\'' + TestData1[i].TestID + '\')" >R</span>';
                              }
                              mydata += '</td>';
                              mydata += '<td id="tdreporttype" style="display:none;">' + TestData1[i].reporttype + '</td>';
                              mydata += '<td id="tdPrePrintedBarcode" style="display:none;">' + TestData1[i].PrePrintedBarcode + '</td>';
                              mydata += '<td id="tdTestID" style="display:none;">' + TestData1[i].TestID + '</td>';
                              mydata += '<td id="tdPerFormingCenter" style="display:none;">' + TestData1[i].PerformingTestCentre + '</td>';
                              mydata += "</tr>";
                              $('#tbsample').append(mydata);
                              if (TestData1[i].PrePrintedBarcode == "1")
                                  $('#txtSINNo').show();
                              if (TestData1[i].IsSampleCollected == "N")
                                  $('#btnsamplecollect').show();

                            }
                        }
                    }
                });
            }
            function setbarcodetoall(ctrl) {
                var val = $(ctrl).val();
                var name = $(ctrl).attr("name");
                $('input[name="' + name + '"]').each(function () {
                    $(this).val(val);
                });
            }
            function samebarcode(ctrl) {
                var value = $(ctrl).val();
                var classname = $(ctrl).attr("class")
                var inputs = $("." + classname);
                for (var i = 0; i < inputs.length; i++) {
                    $(inputs[i]).val(value);
                }
            }
            function setclass(cltr) {
                var value = $(cltr).val();
                var Sampletype = $(cltr).closest("tr").find("#sampletypes").val();
                var classname = $(cltr).closest("tr").find("#tdsinno").attr("class");
                $(cltr).closest("tr").find("#tdsinno").removeClass(classname);
                $(cltr).closest("tr").find("#tdsinno").addClass('sample_' + Sampletype + '')
            }
            function getBarcodeDetail(LedgertransactionNo, Investigation_ID) {
               
                try {
                    serverCall('../Lab/SampleCollectionLab.aspx/getBarcode', { LedgertransactionNo: LedgertransactionNo, Investigation_ID: Investigation_ID  }, function (response) {
                        window.location = 'barcode:///?cmd=' + response + '&Source=barcode_source_lab';
                    });
                }
                catch (e) {
                    madelAlert("Barcode Printer Not Install");
                }
            }
            function GetData() {
                var validate = "0";
                var BarcodeNo = "0";
                var HISTODoctorID = "";
                var HistoCytoSampleDetail = ""
                var SampleTypeID = "";
                var SampleType = "";
                var HistoCytoStatus = "";
                var SampleCollectiondate = "";
                var dataPLO = new Array();
                $('#tbsample tr').each(function () {
                    var id = $(this).closest("tr").attr("id");
                    if (id != "saheader") {
                        if ($(this).closest("tr").find('#mmchk').prop('checked') == true) {
                            if ($(this).closest("tr").find("#tdreporttype").text() == "7") {
                                HISTODoctorID = $(this).find('#ddlDoctorPath').val();
                                HistoCytoSampleDetail = $(this).find('#ddlnoofsp').val() + '^' + $(this).find('#ddlnoofsli').val() + '^' + $(this).find('#ddlnoofblock').val();
                                SampleTypeID = $('#tdss').text();
                                SampleType = $('#txtspecimentype').val();
                                HistoCytoStatus = "Assigned";
                            }
                            else {
                                SampleTypeID = $(this).find('#sampletypes').val();
                                SampleType = $(this).find('#sampletypes option:selected').text();
                            }
                            if ($(this).closest("tr").find("#tdPrePrintedBarcode").text() == "1") {
                                if ($(this).find('#tdsinno').val() == "") {
                                    validate = "1";
                                }
                                else {
                                    BarcodeNo = $(this).find('#tdsinno').val();
                                    if (BarcodeNo != "") {
                                        SampleCollectiondate = $('#spnScRequestdate').text();
                                    }
                                }
                            }
                            else
                                BarcodeNo = $(this).find('#tdsinno').text();
                            if ($(this).closest("tr").find("#sampletypes").val() == "0") {
                                validate = "3";
                            }
                            dataPLO.push($(this).closest("tr").attr("id") + "#" + SampleTypeID + "#" + SampleType + "#" + HISTODoctorID + "#" + BarcodeNo + "#" + $(this).find('#tdPerFormingCenter').text() + "#" + HistoCytoSampleDetail + "#" + HistoCytoStatus + "#" + SampleCollectiondate );
                        }
                    }
                });
                if (validate == "1")
                    return "1";
                else if (validate == "2")
                    return "2";
                else if (validate == "3")
                    return "3";
                else
                    return dataPLO;
            }
            function Validation() {
                var count = 0;
                $('#tbsample tr').each(function () {
                    var id = $(this).closest("tr").attr("id");
                    if (id != "saheader") {
                        if ($(this).closest("tr").find('#mmchk').prop('checked') == true) {

                            var SCRequestdate = $.trim($(this).find('#spnScRequestdatetime').text());
                            var SCWithdrawdate = $.trim($(this).find('#spnScRequestdate').text());

                            if (SCWithdrawdate == "") {
                                SCWithdrawdate = new Date().format("dd-MMM-yy hh:mm tt")

                            }
                            if (SCRequestdate != "") {
                                if (new Date(SCRequestdate) > new Date(SCWithdrawdate)) {
                                    count += 1;
                                    validatemesg = "Request date is greater then Withdraw date";
                                }
                            }
                        }
                    }
                });
                if (count > 0) {
                    return false;
                }
                return true;
            }
            function SampleCollection() {
                if (Validation()) {
                var data = GetData();
                if (data == "1") {
                    modelAlert("Please Enter The Barcode No");
                    return;
                }
                if (data == "2") {
                    modelAlert("Please Select At Least One Sample");
                    return;
                }
                if (data == "3") {
                    modelAlert("Please Select The Sample Type");
                    return;
                }
                if (data.length == 0) {
                    modalAlert("Please Select At least one sample");
                    return;
                }
                else {
                    serverCall('../Lab/SampleCollectionLab.aspx/SaveSamplecollection', { data: data }, function (response) {
                        
                        if (response == "1") {
                            $('#tbsample tr').slice(1).remove();
                            getBarcodeDetail($('#spnledgerno').text() + "#" + "L", "");
                            $('#spnledgerno').text('');
                            modelAlert("Record Saved Successfully", function () { SearchPatientDetails(); });
                        }
                    });
                    }
                }
                else {
                    modelAlert(validatemesg);
                }
            }
            function call() {
                if ($('#hd').prop('checked') == true) {
                    $('#tbsample tr').each(function () {
                        var id = $(this).closest("tr").attr("id");
                        if (id != "saheader") {
                            $(this).closest("tr").find('#mmchk:not(:disabled)').prop('checked', true);
                        }
                    });
                }
                else {
                    $('#tbsample tr').each(function () {
                        var id = $(this).closest("tr").attr("id");
                        if (id != "saheader") {
                            $(this).closest("tr").find('#mmchk:not(:disabled)').prop('checked', false);
                        }
                    });
                }
            }
            $(function () {
                SearchPatientDetails();
            });
        </script>
    </form>
</body>
</html>
