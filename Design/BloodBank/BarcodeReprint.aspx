<%@ Page Language="C#" AutoEventWireup="true" CodeFile="BarcodeReprint.aspx.cs" Inherits="Design_BloodBank_BarcodeReprint" MasterPageFile="~/DefaultHome.master" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35" Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:content id="Content1" contentplaceholderid="ContentPlaceHolder1" runat="Server">
<script type="text/javascript" src="../../Scripts/Message.js"></script>
    <script type="text/javascript">
        function Search() {
            //$('#rdbType option:selected').val();
            if ($("[id*=rdbType] input:checked").val() == "Donor") {

                var BagType = $('#txtBagNo').val();
                var FromDate = $('#txtdatefrom').val();
                var ToDate = $('#txtdateTo').val();

                serverCall('BarcodeReprint.aspx/SearchBarcodeType', { BagType: BagType, FromDate: FromDate, ToDate: ToDate }, function (response) {
                    DonorData = jQuery.parseJSON(response);
                    if (DonorData != "0") {
                        var output = $('#tb_BloodDonorDetails').parseTemplate(DonorData);

                        $('#divDonorDetails').html(output);

                        $('#divDonorDetails').show();
                    }
                    else { modelAlert("No Records Found Against this" + BagType + " No."); }

                });
            }
            else {

                var UHID = $('#txtPatientUHID').val();
                var FromDate = $('#txtdatefrom').val();
                var ToDate = $('#txtdateTo').val();
                var BarcodeCategory = $("[id*=rdbPatient] input:checked").val();
                serverCall('BarcodeReprint.aspx/SearchBarcodePatientType', { UHID: UHID, FromDate: FromDate, ToDate: ToDate, BarcodeCategory: BarcodeCategory }, function (response) {
                    PatientData = jQuery.parseJSON(response);
                    if (PatientData != "0") {
                        var output = $('#tb_patientdetails').parseTemplate(PatientData);

                        $('#divPatientDetail').html(output);
                        $('#divPatientDetail').show();


                    }
                    else { modelAlert("No Records Found Against this" + BagType + " No."); }



                });
            }
        }

        function BarcodePrint(rowid) {
            var BagNo = $(rowid).closest('tr').find("#tdBagno").text();
            var DonorName = $(rowid).closest('tr').find("#tdDname").text();
            var CollectionDate = $(rowid).closest('tr').find("#tdCollectionDate").text();
            var Age = $(rowid).closest('tr').find("#tdAge").text();
            var Gender = $(rowid).closest('tr').find("#tdGender").text();

            var data = "";
            //for (var j = 0; j < 2; j++) {

            data = data + "" + (data == "" ? "" : "^") + BagNo + ',' + DonorName + ',' + CollectionDate + ',' + Age, ',' + Gender;
            //}
            if (data != "") {
                
                window.location = 'barcode:///?cmd=' + data + '&Source=barcode_source_Blood';
            }


            //if (BagNo != "") {
            //    window.open('../BloodBank/PrintAllBarcodeAtCollection.aspx?LedgerTransactionNo=&BagNo=' + BagNo + '&ReportName=');
            //}



        }
        function WriteToFile(barcodeLabel) {
            try {
                //console.log(barcodeLabel);
                window.location = 'barcode://?cmd=' + barcodeLabel + '&source=DonorBagNoWithBarcode';
            }
            catch (e) { }
        }

        function MachineBarcode(rowid)
        {
            var NoOfPrint = $(rowid).closest('tr').find("#txtMachineBarcodePrint").val();
            var BagNo = $(rowid).closest('tr').find("#tdBagno").text();
            var data = "";

            for (var i = 0; i < NoOfPrint; i++)
            {
             data = data + "" + (data == "" ? "" : "^") + BagNo;
         
            }
            if (data != "") {
                WriteToFile(data);
            }
        }
        function BarcodePrintPatientDetails(rowid) {
            var LedgerTransactionNo = $(rowid).closest('tr').find("#tdLedgertransactionNo").text();
            var patientID = $(rowid).closest('tr').find("#tdpatient_ID").text();
            var pmhID = $(rowid).closest('tr').find("#tdPmhID").text();
            if ($("[id*=rdbPatient] input:checked").val() == "WithPatient") {
                if (LedgerTransactionNo != "") {
                    window.open('../BloodBank/PrintAllBarcodeAtCollection.aspx?LedgerTransactionNo=' + LedgerTransactionNo + '&BagNo=' + '&patientID=' + '&ReportName=');
                }
            }
            else if ($("[id*=rdbPatient] input:checked").val() == "PatientReaction") {
                var component = $(rowid).closest('tr').find("#tdComponentID").text();
                if (component == '2' || component == "1") {
                    window.open('PrintAllBarcodeAtCollection.aspx?ReportName=ReactionFrom&PatientID=' + patientID + '&PmhID=' + pmhID + '');
                }
                else { modelAlert('No PRBC OR Whole Blood Issue this Patient'); }

            }
            else if ($("[id*=rdbPatient] input:checked").val() == "WithPatientCrossMatch") {
                window.open('BloodBagBarCode.aspx?LedgerTnxNo=' + LedgerTransactionNo + '&StockID=' + '&patientID' + '&ReportName=');
            }
        }
        var $addbageno = function (sender, e) {
            var inputValue = (e.which) ? e.which : e.keyCode;
            var $txtdonarId = $('#txtBagNo');
            if (inputValue == 13 && $txtdonarId.val().trim() != '') {
                Search();
            }
        }

        var $addPatientBarcode = function (sender, e) {
            var inputValue = (e.which) ? e.which : e.keyCode;
            var $txtdonarId = $('#txtPatientUHID');
            if (inputValue == 13 && $txtdonarId.val().trim() != '') {
                Search();
            }
        }
        </script>
    <script id="tb_BloodDonorDetails" type="text/html">
        <table class="FixedTables" cellspacing="0" rules="all" border="1" id="tb_BloodDonorData" style="width:100%;border-collapse:collapse;">

            <tr id="trHeader">
            <th class="GridViewHeaderStyle" scope="col" style="width:10px;">S.No.</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:120px;">DonorID</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:120px;">Donor Name</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:50px;">MobileNo</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:50px;">VisitId</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:50px;">Barcode No</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:50px;">BagType</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:50px;">BBTubeNo</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:50px;">Print</th>
            <%--<th class="GridViewHeaderStyle" scope="col" style="width:50px;">NoOfPrints</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:50px;">MachineBarcode</th>--%>
                </tr>
             <#       
        var dataLength=DonorData.length;
        window.status="Total Records Found :"+ dataLength;
        var objRow;   
        var status;     
        for(var j=0;j<dataLength;j++)
        {       
        objRow = DonorData[j];
        #>
              <tr id="tr1">                            
                    <td class="GridViewLabItemStyle" style="width:30px;  text-align:center;"><#=j+1#></td>
                    <td class="GridViewLabItemStyle" id="tdID" style="width:200px; " ><#=objRow.DonorID#></td> 
                    <td class="GridViewLabItemStyle" id="tdDname" style="width:200px; " ><#=objRow.Name#></td> 
                    <td class="GridViewLabItemStyle" id="tdBagTypeName" style="width:200px; " ><#=objRow.MobileNo#></td> 
                    <td class="GridViewLabItemStyle" style="width:100px;  text-align:center;" ><#=objRow.VisitId#></td> 
                    <td class="GridViewLabItemStyle" style="width:80px;  text-align:center;" id="idComponentName" ><#=objRow.BloodCollection_Id#></td> 
                    <td class="GridViewLabItemStyle" style="width:100px;  text-align:center;" ><#=objRow.BagType#></td> 
                    <td class="GridViewLabItemStyle" style="width:80px;  text-align:center;" ><#=objRow.BBTubeNo#></td> 
                    <td class="GridViewLabItemStyle" style="width:80px;  display:none" id="tdBagno" ><#=objRow.BloodCollection_Id#></td>
                    <td class="GridViewLabItemStyle" style="width:80px;  display:none" id="tdbleedingDate" ><#=objRow.BleedingDate#></td>
                    <td class="GridViewLabItemStyle" style="width:80px;  display:none" id="tdExpiryDate" ><#=objRow.ExpiryDate#></td>   
                    <td class="GridViewLabItemStyle" style="width:80px;  display:none" id="tdCollectionDate" ><#=objRow.CollectionDate#></td>   
                    <td class="GridViewLabItemStyle" style="width:80px;  display:none" id="tdAge" ><#=objRow.dtBirth#></td>   
                    <td class="GridViewLabItemStyle" style="width:80px;  display:none" id="tdGender" ><#=objRow.Gender#></td>   
                   <td class="GridViewLabItemStyle" style="width:30px; text-align:center;" ><img id="imgPrint" src="../../Images/Post.gif" onclick="BarcodePrint(this);" title="Click To Print Barcode" /></td>
                  <%--  <td class="GridViewLabItemStyle" style="width:80px;  " ><input  type="text"  id="txtMachineBarcodePrint"/></td>
                  <td class="GridViewLabItemStyle" style="width:30px; text-align:center;" ><img id="imgMachineBarcode" src="../../Images/Post.gif" onclick="MachineBarcode(this);" title="Click To Print Barcode" /></td>--%>
                </tr> 
             <#}#>  
            </table>
        </script>
    
        <script id="tb_patientdetails" type="text/html">
        <table class="FixedTables" cellspacing="0" rules="all" border="1" id="tblPatientDetails" style="width:100%;border-collapse:collapse;">

            <tr id="tr4">
            <th class="GridViewHeaderStyle" scope="col" style="width:10px;">S.No.</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:120px;">HospitalName</th>
             <th class="GridViewHeaderStyle" scope="col" style="width:120px;">Pname</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:120px;">PatientID</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:50px;">Mobile</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:50px;">EntryDate</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:50px;">ComponentName</th>
        
            <th class="GridViewHeaderStyle" scope="col" style="width:50px;">Print</th>
                </tr>
             <#       
        var dataLength=PatientData.length;
        window.status="Total Records Found :"+ dataLength;
        var objRow;   
        var status;     
        for(var j=0;j<dataLength;j++)
        {       
        objRow = PatientData[j];
        #>
              <tr id="tr5">                            
                    <td class="GridViewLabItemStyle" style="width:30px;  text-align:center;"><#=j+1#></td>
                    <td class="GridViewLabItemStyle" id="tdHospitalName" style="width:200px;text-align:center; "  ><#=objRow.HospitalName#></td> 
                    <td class="GridViewLabItemStyle" id="tdPname" style="width:200px;text-align:center; " ><#=objRow.Pname#></td> 
                    <td class="GridViewLabItemStyle" id="tdpatient_ID" style="width:200px;text-align:center; " ><#=objRow.Patient_ID#></td> 
                    <td class="GridViewLabItemStyle" id="tdMobileNo" style="width:200px;text-align:center; " ><#=objRow.Mobile#></td> 
                    <td class="GridViewLabItemStyle" id="tdEntryDate" style="width:100px;  text-align:center;" ><#=objRow.DATE#></td> 
                    <td class="GridViewLabItemStyle" style="width:80px;  text-align:center;" id ="tdCompnentName"><#=objRow.ComponentName#></td>
                    <td class="GridViewLabItemStyle" style="width:80px;  text-align:center;display:none" id ="tdLedgertransactionNo"><#=objRow.LedgerTransactionNo#></td> 
                   <td class="GridViewLabItemStyle"  id="tdPmhID"style="width:80px;  text-align:center;display:none" ><#=objRow.PmhID#></td> 
                  <td class="GridViewLabItemStyle"  id="tdComponentID"style="width:80px;  text-align:center;display:none" ><#=objRow.ComponentID#></td> 
        
                     <td class="GridViewLabItemStyle" style="width:30px; text-align:center;"><img id="imgpatientdetails" src="../../Images/Post.gif" onclick="BarcodePrintPatientDetails(this);" title="Click To Print Barcode" /></td>
                </tr> 
             <#}#>  
            </table>
        </script>

<Ajax:ScriptManager ID="ScriptManager1" runat="server">
    </Ajax:ScriptManager>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">

            <b>BardCode Reprint</b><br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
        </div>
        <div class="POuter_Box_Inventory">
            <div id="Div1" class="Purchaseheader" runat="server">
                Search Criteria
            </div>
        
         <div class="row" id="donor">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                     <div class="row" style="display:none">
                        <div class="col-md-3" >
                            <label class="pull-left">
                                BarcodeType
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                         <div class="col-md-5">
                            <asp:RadioButtonList ID="rdbType" runat="server" TabIndex="1" RepeatDirection="Horizontal" ClientIDMode="Static">
                                <asp:ListItem Text="Donor" Value="Donor" Selected="True"></asp:ListItem>
                                <asp:ListItem Text="Patient" Value="Patient"></asp:ListItem>
                            </asp:RadioButtonList>
                        </div>
                    
                    </div>
                    <div class="row">
                             <div class="col-md-3">
                            <label class="pull-left">
                                Barcode No
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                         <div class="col-md-5">
                          <asp:TextBox ID="txtBagNo" onkeyup="$addbageno(this,event);" runat="server" ClientIDMode="Static" ToolTip="Enter Patient Blood CollectionID"></asp:TextBox>
                        </div>
                         <div class="col-md-3">
                            <label class="pull-left">
                                From Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtdatefrom" runat="server" ClientIDMode="Static" TabIndex="4"></asp:TextBox>
                            <cc1:CalendarExtender ID="calfrom" TargetControlID="txtdatefrom" Format="dd-MMM-yyyy"
                                Animated="true" runat="server">
                            </cc1:CalendarExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                To Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtdateTo" runat="server" ClientIDMode="Static" TabIndex="5"></asp:TextBox>
                            <cc1:CalendarExtender ID="calto" TargetControlID="txtdateTo" Format="dd-MMM-yyyy"
                                Animated="true" runat="server">
                            </cc1:CalendarExtender>
                        </div>

                    </div>
                    <div class="row" id="patientBarcode" style="display:none" >
                          <div class="col-md-3">
                            <label class="pull-left">
                                UHID
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                          <asp:TextBox ID="txtPatientUHID"  onkeyup="$addPatientBarcode(this,event);" runat="server" ClientIDMode="Static"></asp:TextBox>
                        </div>
                      
                    </div>
                    <div class="row" style="display:none">
                      
                         <div class="col-md-3">
                            <label class="pull-left">
                                Barcode Cat.
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                         <div class="col-md-10">
                          <asp:RadioButtonList ID="rdbPatient" runat="server" TabIndex="1" RepeatDirection="Horizontal" ClientIDMode="Static">
                                <asp:ListItem Text="WithPatient" Value="WithPatient" Selected="True"></asp:ListItem>
                        
                              <asp:ListItem Text="WithPatientCrossMatch" Value="WithPatientCrossMatch"></asp:ListItem>
                              <asp:ListItem Text="PatientReaction" Value="PatientReaction"></asp:ListItem>
                            </asp:RadioButtonList>
                        </div>
                    </div>
             </div>

             <div class="row">


             </div>

             </div>
            </div>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <div class="row">
                <div class="col-md-9">
                 
                </div>
                <div class="col-md-6" style="text-align: center;">
                    
                    <input type="button" id="btnSearch" class="ItdoseButton" value="Search" onclick="Search();" />
                </div>
                <div class="col-md-9"></div>
            </div>
        </div>
        <div class="POuter_Box_Inventory" >
            <div class="Purchaseheader">Donor/Patient Details</div>
            <div class="row">
                <div id="divDonorDetails" style="max-height: 250px; overflow-x: auto; display:none"></div>
                <div id="divPatientDetail" style="max-height: 250px; overflow-x: auto; display:none"></div>
            </div>
        </div>
         
        </div>
    </div>
    </asp:content>