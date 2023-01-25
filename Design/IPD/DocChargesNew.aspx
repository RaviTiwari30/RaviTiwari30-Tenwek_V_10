<%@ Page Language="C#" AutoEventWireup="true" CodeFile="DocChargesNew.aspx.cs" Inherits="Design_IPD_DocChargesNew" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Untitled Page</title>
    
</head>
<body>
         <%: System.Web.Optimization.Scripts.Render("~/bundle/folderinjs") %>
    <%: System.Web.Optimization.Styles.Render("~/bundle/folderincss") %>

    <script type="text/javascript">
        function SetColor(chk) {
            if (chk.checked)
                chk.parentNode.style.backgroundColor = "#ede49e"; //pending   
            else
                chk.parentNode.style.backgroundColor = "#EAF3FD"; //normal
        }
        var output = "";
        $(document).ready(function () {
            $('#ddlDoctor').chosen();
            $('#ddlDoctor').change(function () {
                Button1_onclick();
            })
            Button1_onclick();
        })
        function Button1_onclick() {
            $("#btnSearch").val('Loading.......').attr('disabled', 'disabled');
            
            $(document).ready(function () {
                $("input :button").attr('disabled', true);               
                    $.ajax(
                        {
                            url: "../Doctor/Services/IPDVisitService.asmx/GetIPDVisit",
                            data: '{TransactionID: "' + $('#lblTransactionNo').text() + '",DoctorID: "' + $('#ddlDoctor').val() + '",RoomTypeID: "' + $('#lblCaseTypeID').text() + '",PanelID: "' + $('#lblPanelID').text() + '",ScheduleChargeID:"' + $('#lblReferenceCode').text() + '"}',
                        type: "POST",
                        contentType: "application/json; charset=utf-8",
                        timeout: 120000,
                        dataType: "json",
                        success: function (result) {                  
                        output = jQuery.parseJSON(result.d);
                        if (output.length > 0) {
                            $("#btnSave").show();
                            var htmloutput = $('#tb_InvestigationItems').parseTemplate(output);
                            $('#DrVisit').html(htmloutput);                      
                            $("#btnSave").val('Save').removeAttr('disabled');
                        }
                        else {
                            alert('No Record Found');
                        }                      
                        $("input :button").attr('disabled', false);                      
                        $("#btnSearch").val('Search').removeAttr('disabled');
                    },
                    error: function (xhr, status) {
                        alert("Error ");
                    }
                
                })
            });

        }    
        function submitting() {
            if (Page_IsValid) {              
                $("#btnSave").val('Submitting...').attr('disabled', 'disabled');
            }
            else {
                $("#btnSave").val('Save').removeAttr('disabled');
            }
        }
        function btnSave_onclick() {
            submitting();
           
            $(document).ready(function () {
                var data = '';
                var header = 'VisitDate,SubcategoryID,ItemID,Rate,rateListID,itemcode';
                data = data + "_";
                var date = "";
                var a = 0;
                $('#DoctorVistiGrid tr').each(function () {
                    var int = 0;
                  
                    $(this).find('td').each(function () {
                        if ($(this).find('label').text().length > 0) {
                            if ($(this).find('label').attr('class') == "date") {
                                date = $(this).find('label').text() + ",";
                            }
                            else {
                                if ($(this).find(':checkbox').attr('checked')) {
                                    if (!$(this).find(':checkbox').attr('disabled')) {
                                        data += date;
                                        data += $(this).find('label').text().replace('_', ',').replace('_', ',').replace('_', ',').replace('_', ',');
                                        data += "_";
                                    }
                                }
                            }
                        }
                        int += 1;
                    });
                });
                if (data.length > 1) {
                    data = header + data;
                    data = data.substr(0, data.length - 1);
                    $.ajax({
                        url: "../Doctor/Services/IPDVisitService.asmx/SaveIPDVisit",
                        data: '{Data: "' + data + '",PatientID: "' + $('#lblPatientID').text() + '",TransactionID: "' + $('#lblTransactionNo').text() + '",userID: "' + $('#lbluserID').text() + '",PanelID: "' + $('#lblPanelID').text() + '",ItemName: "' + $('#ddlDoctor :selected').text() + '",DoctorID: "' + $('#ddlDoctor').val() + '",IPDCaseType_ID: "' + $('#lblCaseTypeID').text() + '",PatientType:"' + $('#lblPatientType').text() + '",Room_ID: "' + $('#lblRoomID').text() + '"}',
                        type: "POST",
                        contentType: "application/json; charset=utf-8",
                        timeout: 120000,
                        dataType: "json",
                        success: function (result) {
                            if (result.d == 1) {
                                $('#lblMsg').text('Record Save Successfully');                            
                                Button1_onclick();                          
                            }
                            else if (result.d == 2) {
                                $('#lblMsg').text('Rate is Not Set  Under this Panel & RoomType. Please contact EDP to Set Rate');
                            }
                            else {
                                $('#lblMsg').text('Record Not Saved');                            
                            }
                            $("#btnSave").val('Save').removeAttr('disabled');
                        },
                        error: function (xhr, status) {
                            $('#lblMsg').text('Record Not Saved');
                            $("#btnSave").val('Save').removeAttr('disabled');

                       }
                    });
                }
                else {
                    alert('Select Dr. Visit');                
                    $("#btnSave").val('Save').removeAttr('disabled');
                }
            });          
        }

        var sendSms = function () {
            if ($('#ddlDoctor').val() == '0') {
                modelAlert('Please Select Doctor to send SMS', function () {
                    $('#ddlDoctor').focus();
                });
            }
            modelConfirmation('Are You Sure?', 'Do You Want to Send SMS', 'Continue', 'Cancel', function (result) {
                if (result)
                    serverCall('../Doctor/Services/IPDVisitService.asmx/SendSMSforCrossConsultation', { doctorID: $('#ddlDoctor').val(), doctorName: $('#ddlDoctor option:selected').text(), patientID: $('#lblPatientID').text(), transactionID: $('#lblTransactionNo').text() }, function (response) {
                        var responseData = JSON.parse(response);
                        modelAlert(responseData.response);
                    });
            });
        }
        var openSmsModal = function () {
            $('#divViewSMSModal').showModel();
            getSmsRequestDetail();
        }
        var getSmsRequestDetail = function () {
            serverCall('../Doctor/Services/IPDVisitService.asmx/getSMSDetailforCrossConsultation', { patientID: $('#lblPatientID').text(), transactionID: $('#lblTransactionNo').text() }, function (response) {
                var responseData = JSON.parse(response);
                bindDetails(responseData);
            });
        }
        var bindDetails = function (data) {
            $('#tbSmsDetails tbody').empty();
            for (var i = 0; i < data.length; i++) {
                var j = $('#tbSmsDetails tbody tr').length + 1;
                var row = '<tr>';
                row += '<td class="GridViewLabItemStyle" style="text-align: center;">' + j + '</td>';
                row += '<td id="tdAName" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].Doctor + '</td>';
                row += '<td id="tdAName" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].Mobile_No  + '</td>';
                row += '<td id="tdAName" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].smsStatus + '</td>';
                row += '<td id="tdAName" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].SMSRequestAt + '</td>';
                row += '<td id="tdAName" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].SMSRequestBy + '</td>';
                row += '</tr>';
                $('#tbSmsDetails tbody').append(row);
            }
        }
    </script>


    <form id="form1" runat="server">
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory">
            <div class="content" style="text-align: center;">
                <b>Doctor Charges</b>
                <br />
                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" ClientIDMode="Static"></asp:Label>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
                <div class="row">
                    <div class="col-md-3">
                        <label class="pull-left">Doctor</label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-6">
                        <asp:DropDownList ID="ddlDoctor" ClientIDMode="Static" runat="server" Width="" CssClass="requiredField" />
                <asp:RequiredFieldValidator ID="reqshelf1" SetFocusOnError="true" runat="server" ControlToValidate="ddlDoctor"
                        ValidationGroup="doc" InitialValue="0" ErrorMessage="Please Select Doctor" Display="None"></asp:RequiredFieldValidator>
                    </div>
                    <div class="col-md-3">
                            <input id="btnSearch" type="button" class="ItDoseButton" title="Click to Search" value="Search" onclick="return Button1_onclick()" />
                    </div>
                    <div class="col-md-3">
                    </div>
                    <div class="col-md-6" style="display:none">
                        <input type="button" id="btnSendSms" value="Send SMS for Cross Consultation" onclick="sendSms()" />
                    </div>
                    <div class="col-md-3" style="display:none">
                        <input type="button" id="btnViewSms" value="View SMS" onclick="openSmsModal()" />
            </div>
        </div>
            </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader" style="text-align: center;">
                <span style="background-color: orchid">Verified Visits</span> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            </div>
            <div class="content" style="text-align: center;">
                    <div id="DrVisit" style="text-align: center; overflow-y: scroll; height: 400px; width: 99%">
                </div>
                <br />
                <div style="text-align: center;">
                    <input id="btnSave" type="button" runat="server" class="ItDoseButton" title="Click to Save" value="Save" onclick="return btnSave_onclick()"
                            style="display: none" />
                    </div>
            </div>
        </div>
        <asp:Label ID="lblTransactionNo" runat="server" Style="display: none" ClientIDMode="Static"></asp:Label>
        <asp:Label ID="lblCaseTypeID" runat="server" Style="display: none" ClientIDMode="Static"></asp:Label>
        <asp:Label ID="lblReferenceCode" runat="server" Style="display: none" ClientIDMode="Static"></asp:Label>
        <asp:Label ID="lblPanelID" runat="server" Style="display: none" ClientIDMode="Static"></asp:Label>
        <asp:Label ID="lblPatientID" runat="server" Style="display: none" ClientIDMode="Static"></asp:Label>
        <asp:Label ID="lbluserID" runat="server" Style="display: none" ClientIDMode="Static"></asp:Label>
         <asp:Label ID="lblPatientType" runat="server" Style="display: none" ClientIDMode="Static"></asp:Label>
        <asp:Label ID="lblRoomID" runat="server" Style="display: none" ClientIDMode="Static"></asp:Label>
    </div>
    <script id="tb_InvestigationItems" type="text/html">
        <table class="GridViewStyle" cellspacing="0" rules="all" border="1" id="DoctorVistiGrid" style="border-collapse:collapse;">
		<tr>
		<th id="tdSno" class="GridViewHeaderStyle" scope="col" style="width:20px;">S.No.</th>
		<#
				for(var i in output[0])
				{
		#>
		<th id="tdSno" class="GridViewHeaderStyle" scope="col" style="width:20px;">
		
		
		<#=i.replace('_s_','^').split('^')[0]#>
		
		<label style="display:none" id="lbl"><#=i.replace('_s_','^').split('^')[0]#></label>
		</th>
		<#
		}
		#>
		
        </tr>
        <#
        var datalenght=output.length;
        
        window.status="Total Record Found :"+datalenght;
        var rowobj;
        for(var j=0;j<datalenght;j++)
        {
        rowobj=output[j];
        #>
        <tr >
        <td id="tdSno" class="GridViewLabItemStyle" ><#=j+1#></td>
        <#
        for(var k in rowobj)
        {
        #>
        
        <td class="GridViewLabItemStyle" style="width:120px;">
        
        
        <#
        
        if(k!='VisitDate')
        {
        
        
        #>
        
        
        <input  type="checkbox" class="cbox" id="chk" <# if(rowobj[k]=='1'){#> checked="checked" disabled="disabled" style="background-color: Orchid" <#}#> />
        <label style="display:none" class="col" id="lblID" ><#=k.replace('_s_','^').split('^')[1]#></label>
        <#
        }
        else
        {
        #>
        <label id="lblDate" class="date" style="font-weight:bold"><#=rowobj[k]#></label>
        
        <#
        }
        #>
        </td>
        <#
        }
        }
        #>
     </table>    
    </script>
    </form>
     <div id="divViewSMSModal"   class="modal fade ">
		<div class="modal-dialog">
			<div class="modal-content" style="background-color:white;width:900px;height:500px">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="divViewSMSModal" aria-hidden="true">&times;</button>
					<h4 class="modal-title">SMS Detail for Cross Consultation Request</h4>
				</div>
				<div class="modal-body">
                    <div id="divList" style="max-height: 400px;height: 380px; overflow-x: auto">
                        <table class="FixedHeader" id="tbSmsDetails" cellspacing="0" rules="all" border="1" style="width: 100%; border-collapse: collapse">
                            <thead>
                                <tr>
                                    <th class="GridViewHeaderStyle" style="width: 30px;">SrNo</th>
                                    <th class="GridViewHeaderStyle" style="width: 150px;">Doctor Name</th>
                                    <th class="GridViewHeaderStyle" style="width: 80px;">Mobile No </th>
                                    <th class="GridViewHeaderStyle" style="width: 100px;">SMS Status</th>
                                    <th class="GridViewHeaderStyle" style="width: 150px;">SMS Request At</th>
                                    <th class="GridViewHeaderStyle" style="width: 150px;">SMS Request By</th>
                                </tr>
                            </thead>
                            <tbody></tbody>
                        </table>
                     </div>
                 </div>
				  <div class="modal-footer">
						 <button type="button"  data-dismiss="divViewSMSModal" >Close</button>
				</div>
                </div>
			</div>
		</div>
</body>
</html>
