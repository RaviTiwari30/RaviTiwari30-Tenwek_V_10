<%@ Page Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="CreateToken.aspx.cs" Inherits="Design_Token_CreateToken" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript">
        $(document).ready(function () {
            tokenSearch();
        });
        window.setInterval(function () {
            tokenSearch();
        }, 5000);
        function tokenSearch() {
            $.ajax({
                type: "POST",
                url: "Services/token.asmx/searchToken",
                data: '{}',
                dataType: "json",
                contentType: "application/json;charset=UTF-8",
                async: true,
                success: function (response) {
                    token = jQuery.parseJSON(response.d);
                    if (token != null) {
                        var output = $('#tb_SearchToken').parseTemplate(token);
                        //$('#OPDTokenOutput').html(output);
                        $('#OPDTokenOutput').html(output).customFixedHeader();
                        $('#OPDTokenOutput').show();
                    }
                    else {
                        $('#OPDTokenOutput').hide();
                    }
                },
                error: function (xhr, status) {
                    window.status = status + "\r\n" + xhr.responseText;

                }

            });
        }
        function chngcur() {
            document.body.style.cursor = 'pointer';
        }
        function createTokenNo(rowid) {
            $(rowid).closest('tr').find('#btnCreateToken').prop("disabled", "disabled");
            var AppID = $(rowid).closest('tr').find('#tdAppID').text();
            $.ajax({
                type: "POST",
                url: "Services/token.asmx/createToken",
                data: '{AppID:"' + AppID + '"}',
                dataType: "json",
                contentType: "application/json;charset=UTF-8",
                async: true,
                success: function (response) {
                    tokenNo = response.d;
                    if (tokenNo != 0) {
                        modelAlert('Patient Token No.' + tokenNo + '', function () {
                            tokenSearch();
                        });
                    }
                    else {

                    }
                },
                error: function (xhr, status) {
                    window.status = status + "\r\n" + xhr.responseText;
                    $(rowid).closest('tr').find('#btnCreateToken').removeProp("disabled");
                }

            });
        }

        function CancelToken(rowid) {
            var AppID = $(rowid).closest('tr').find('#tdAppID').text();
            $.ajax({
                type: "POST",
                url: "Services/token.asmx/CancelToken",
                data: '{AppID:"' + AppID + '"}',
                dataType: "json",
                contentType: "application/json;charset=UTF-8",
                async: true,
                success: function (response) {
                    if (response.d == "1") {
                        tokenSearch();
                    }
                },
                error: function (xhr, status) {
                    window.status = status + "\r\n" + xhr.responseText;
                    $(rowid).closest('tr').find('#btnCreateToken').removeProp("disabled");
                }

            });
        }
        function Search() {
            var TokenNumber = $('[id$=txttokenno]').val();
            var PatientName = $('[id$=txtPatientname]').val();
            var DoctorName = $('[id$=txtdoctorname]').val();
            if (PatientName == "" && DoctorName == "" && TokenNumber == "") {
                modelAlert('Please Enter Any Searching Criteria..', function () {
                    return false;
                });
            }
            else {
                $.ajax({
                    type: "POST",
                    url: "CreateToken.aspx/searchOPDToken",
                    data: '{PatientName:"' + PatientName + '",DoctorName:"' + DoctorName + '",TokenNumber:"' + TokenNumber + '"}',
                    dataType: "json",
                    contentType: "application/json;charset=UTF-8",
                    async: true,
                    success: function (response) {
                        token = jQuery.parseJSON(response.d);
                        if (token != null) {
                            var output = $('#tb_SearchToken').parseTemplate(token);
                            //$('#OPDTokenOutput').html(output);
                            $('#OPDTokenOutput').html(output).customFixedHeader();
                            $('#OPDTokenOutput').show();
                            $('[id$=txttokenno]').val('');
                            $('[id$=txtPatientname]').val('');
                            $('[id$=txtdoctorname]').val('');
                        }
                        else {
                            modelAlert('No Record Found..', function () {
                                $('[id$=txttokenno]').val('');
                                $('[id$=txtPatientname]').val('');
                                $('[id$=txtdoctorname]').val('');
                                $('#OPDTokenOutput').hide();
                            });
                        }
                    },
                    error: function (xhr, status) {
                        window.status = status + "\r\n" + xhr.responseText;
                    }
                });
            }
        }

    </script>
    <div id="Pbody_box_inventory">
        <cc1:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server" EnableScriptGlobalization="true"
            EnableScriptLocalization="true">
        </cc1:ToolkitScriptManager>

        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>OPD Token List</b>
            <br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" ClientIDMode="Static" />
        </div>
        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-8"></div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Appointment Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:Label ID="lblAppointmentDate" runat="server"
                                Font-Bold="true"
                                ClientIDMode="Static"></asp:Label>
                        </div>
                        <div class="col-md-8"></div>
                    </div>
                </div>
            </div>
            <div class="Purchaseheader">
                Search Criteria
            </div>
            <div class="row">
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Patient Name 
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <input type="text" id="txtPatientname" />
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Doctor Name
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <input type="text" id="txtdoctorname" />
                        </div>
                        <div class="col-md-1"></div>
                        <div class="col-md-2">
                            <label class="pull-left">
                                Token No.
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <input type="text" id="txttokenno" />
                        </div>
                    </div>
                </div>

            </div>
            <div class="row" style="text-align: center">
                <input type="button" id="btnsearch" value="Search" class="itdosebutton" onclick="Search();" />
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-5"></div>
                        <div style="text-align: center" class="col-md-5">
                            <button type="button" style="width: 25px; height: 25px; margin-left: 5px; float: left; background-color: yellow;" class="circle"></button>
                            <b style="margin-top: 5px; margin-left: 5px; float: left">Token Not Assigned</b>
                        </div>
                        <div style="text-align: center" class="col-md-5">
                            <button type="button" style="width: 25px; height: 25px; margin-left: 5px; float: left; background-color: #90ee90;" class="circle"></button>
                            <b style="margin-top: 5px; margin-left: 5px; float: left">Token Assigned</b>
                        </div>
                        <div style="text-align: center" class="col-md-5">
                            <button type="button" style="width: 25px; height: 25px; margin-left: 5px; float: left; background-color: #FF0000;" class="circle"></button>
                            <b style="margin-top: 5px; margin-left: 5px; float: left">Token Cancelled</b>
                        </div>
                        <div class="col-md-4"></div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div id="OPDTokenOutput" style="max-height: 400px; overflow-x: auto;">
            </div>
        </div>
    </div>
    <script id="tb_SearchToken" type="text/html">
         <table class="FixedTables" cellspacing="0" rules="all" border="1" id="tb_grdOPDFinalSettlement"
    style="width:100%;border-collapse:collapse;">
             <thead>
		<tr id="Header">
			<th class="GridViewHeaderStyle" scope="col" style="width:10px;">S.No.</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:50px;">App. No.</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:80px;">App. Date</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:90px;">UHID</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:160px;">Patient Name</th>			
            <th class="GridViewHeaderStyle" scope="col" style="width:160px;">Doctor Name</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:60px;">Token No.</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:60px; display:none ">AppID</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:60px; display:none ">LedgertransactionNo</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:60px;display:none">TransactionID</th>			 
            <th class="GridViewHeaderStyle" scope="col" style="width:30px;">Create Token</th> 
             <th class="GridViewHeaderStyle" scope="col" style="width:30px;">Cancel Token</th>          
		</tr>
                 </thead>
             <tbody>
        <#       
        var dataLength=token.length;
        window.status="Total Records Found :"+ dataLength;
        var objRow;   
        var status;
        for(var j=0;j<dataLength;j++)
        {       
        objRow = token[j];
        #>
                    <tr id="<#=j+1#>" 
                        <# if(objRow.tokenNoExit!="0"&&objRow.IsCancelToken=="0"){#>
					style="background-color:#90ee90"
				   <#} else if(objRow.IsCancelToken=="2"&&objRow.tokenNoExit=="1"){#>
					style="background-color:#FF0000"
				    <#} else{#>
					style="background-color:yellow"
				    <#} #>
                        >                            
                    <td class="GridViewLabItemStyle" style="width:10px;text-align:center"><#=j+1#></td>
                    <td class="GridViewLabItemStyle" id="tdAppNo"  style="width:50px;text-align:center" ><#=objRow.AppNo#></td>
                    <td class="GridViewLabItemStyle" id="tdAppDate"  style="width:80px;text-align:center" ><#=objRow.AppDate#></td>
                    <td class="GridViewLabItemStyle" id="tdPatientID"  style="width:90px;text-align:center" ><#=objRow.PatientID#></td>
                    <td class="GridViewLabItemStyle" id="tdPatientName" style="width:160px;text-align:left"><#=objRow.NAME#></td>
                    <td class="GridViewLabItemStyle" id="tdDoctorName" style="width:160px;text-align:left"><#=objRow.DoctorName#></td>
                    <td class="GridViewLabItemStyle" id="tdtokenNo" style="width:60px; text-align:center;font-size:medium;font:bold;color: green"><#=objRow.tokenNo#></td>
                    <td class="GridViewLabItemStyle" id="tdAppID" style="width:60px;display:none"><#=objRow.App_ID#></td>                     
                    <td class="GridViewLabItemStyle" id="tdLedgertransactionNo" style="width:60px;display:none"><#=objRow.LedgertransactionNo#></td>
                    <td class="GridViewLabItemStyle" id="tdTransactionID"  style="width:60px;display:none" ><#=objRow.TransactionID#></td>                                                                        
                    <td class="GridViewLabItemStyle" style="width:30px; text-align:center">
                        <input type="button" value="Create Token"   id="btnCreateToken"  class="ItDoseButton" onclick="createTokenNo(this);"                       
                            <#if(objRow.IsCancelToken=="3"){#>
                             <#} else if(objRow.tokenNoExit=="1"&&objRow.token!=""){#>disabled="disabled"<#}#> 
                          />                                                    
                    </td> 
                         <td class="GridViewLabItemStyle" style="width:30px; text-align:center">
                             <input type="button" value="Cancel Token" id="BtnCancelToken" class="ItDoseButton" onclick="CancelToken(this);"  
                                  <#if(objRow.IsCancelToken=="2"||objRow.tokenNoExit=="0"){#>
                                    disabled="disabled"<#}else if(objRow.IsCancelToken=="3"){#>disabled="disabled"<#} #>  />
                             </td>
                    </tr>            
        <#}        
        #>      
            </tbody>
     </table>
    </script>
</asp:Content>

