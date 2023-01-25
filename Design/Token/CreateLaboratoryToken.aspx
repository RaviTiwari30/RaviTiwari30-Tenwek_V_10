<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="CreateLaboratoryToken.aspx.cs" Inherits="Design_Token_CreateLaboratoryToken" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <script type="text/javascript">
        $(document).ready(function () {
            tokenSearch();
            $bindSubCategory(4, 'LSHHI3', function () { });
            $onInit();
        });
        window.setInterval(function () {
            tokenSearch();
        }, 15000);
        function tokenSearch() {
            $.ajax({
                type: "POST",
                url: "CreateLaboratoryToken.aspx/SearchToken",
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
            var OldID = '';
            $(rowid).closest('tr').find('#btnCreateToken').prop("disabled", "disabled");
            if ($(rowid).closest('tr').find('#chkSelect').prop('checked') == false) {
                modelAlert('Please Select Item.', function () {
                    return false;
                });
            }
            else {
                var LedgerTransactionNo = $(rowid).closest('tr').find('#tdLedgerTransactionNo').text();
                $("#tbl_Laboratory_TokenList tr").each(function (index) {
                    if (index > 0) {
                        if ($(this).find('[id$=chkSelect]').prop('checked') == true) {
                            var ID = $(this).find('#tdTest_ID').text();
                            var LTNo = $(this).find('#tdLedgerTransactionNo').text();
                            if (LedgerTransactionNo == LTNo) {
                                OldID += "'" + ID + "'" + ',';
                            }
                        }
                    }
                });
                var Test_ID = $(rowid).closest('tr').find('#tdTest_ID').text();
                var TestID = OldID.slice(0, -1);
                var LabInvestID = $(rowid).closest('tr').find('#tdLabInvestID').text();
                $.ajax({
                    type: "POST",
                    url: "CreateLaboratoryToken.aspx/createToken",
                    data: '{LedgerTransactionNo:"' + LedgerTransactionNo + '",Test_ID:"' + Test_ID + '",TestID:"' + TestID + '",LabInvestID:"' + LabInvestID + '"}',
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
        }
        function CancelToken(rowid) {
            var OldID = '';
            $(rowid).closest('tr').find('#btnCreateToken').prop("disabled", "disabled");
            if ($(rowid).closest('tr').find('#chkSelect').prop('checked') == false) {
                modelAlert('Please Select Item.', function () {
                    return false;
                });
            }
            else {
                var LedgerTransactionNo = $(rowid).closest('tr').find('#tdLedgerTransactionNo').text();
                $("#tbl_Laboratory_TokenList tr").each(function (index) {
                    if (index > 0) {
                        if ($(this).find('[id$=chkSelect]').prop('checked') == true) {
                            var ID = $(this).find('#tdTest_ID').text();
                            var LTNo = $(this).find('#tdLedgerTransactionNo').text();
                            if (LedgerTransactionNo == LTNo) {
                                OldID += "'" + ID + "'" + ',';
                            }
                        }
                    }
                });
                //var Test_ID = $(rowid).closest('tr').find('#tdTest_ID').text();
                var Test_ID = OldID.slice(0, -1);
                $.ajax({
                    type: "POST",
                    url: "CreateLaboratoryToken.aspx/CancelToken",
                    data: '{LedgerTransactionNo:"' + LedgerTransactionNo + '",Test_ID:"' + Test_ID + '"}',
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
        }

        $bindSubCategory = function (labItem, categoryID, callback) {
            $subCategory = $('#ddlSubCategory');
            serverCall('../common/CommonService.asmx/BindSubCategory', { Type: labItem, CategoryID: categoryID }, function (response) {
                $subCategory.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'SubCategoryID', textField: 'Name', isSearchAble: true });
                callback($subCategory.val());
            });
        }

        $onInit = function () {
            $('#txtSearch').autocomplete({
                source: function (request, response) {
                    if ($('[id$=ddlSubCategory]').val() == null || $('[id$=ddlSubCategory]').val() == "0") {
                        modelAlert('Please Select Department.', function () {
                            $('#txtSearch').val('');
                            return false;
                        });
                        $('#txtSearch').val('');
                        return false;
                    }
                    $labItem = 4;
                    $categoryID = 'LSHHI3';
                    $subCategoryID = $('#ddlSubCategory').val();
                    $searchType = 1;
                    $bindItems({ searchType: parseInt($searchType), prefix: request.term, Type: $labItem, CategoryID: $categoryID, SubCategoryID: $subCategoryID, itemID: '' }, function (responseItems) {
                        response(responseItems)
                    });
                },
                select: function (e, i) {
                    //$validateInvestigation(i, 0, 0, 1, function () { });
                    $validateInvestigation(i, function () { });
                },
                focus: function (e, i) {
                    // console.log(i);
                },
                close: function (el) {
                    el.target.value = '';
                },
                minLength: 2
            });
            //onPatientIDChange(function () { });
        }
        $bindItems = function (data, callback) {
            serverCall('../common/CommonService.asmx/LoadOPD_All_ItemsLabAutoComplete', data, function (response) {
                var responseData = $.map(JSON.parse(response), function (item) {
                    return {
                        label: item.AutoCompleteItemName,
                        val: item.Item_ID,
                        isadvance: item.isadvance,
                        IsOutSource: item.IsOutSource,
                        ItemCode: item.ItemCode,
                        Type_ID: item.Type_ID,
                        LabType: item.LabType,
                        TnxTypeID: item.TnxType,
                        SubCategoryID: item.SubCategoryID,
                        sampleType: item.Sample,
                        TypeName: item.TypeName,
                        rateEditAble: item.RateEditable
                    }
                });
                callback(responseData);
            });
        }
        $validateInvestigation = function (ctr, callback) {
            if (ctr.item.val.trim() != "") {
                var strItem = ctr.item.val;
                $('[id$=lblItemName]').text(ctr.item.label);
                $('[id$=lblItemName]').val(strItem);
            }
        };
        function Search() {
            var LabNo = $('[id$=txtlabNo]').val();
            var PatientName = $('[id$=txtPatientname]').val();
            var DepartmentId = $('[id$=ddlSubCategory]').val();
            var InvestigationId = $('[id$=lblItemName]').val();
            var Token = $('[id$=txttokenno]').val();
            if (LabNo == "" && PatientName == "" && DepartmentId == "0" && InvestigationId == "" && Token=="") {
                modelAlert('Please Select Department..', function () {
                    return false;
                });
            }
            else {
                $.ajax({
                    type: "POST",
                    url: "CreateLaboratoryToken.aspx/SearchTokenNumber",
                    data: '{LabNo:"' + LabNo + '",PatientName:"' + PatientName + '",DepartmentId:"' + DepartmentId + '",InvestigationId:"' + InvestigationId + '",Token:"' + Token + '"}',
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
                            $('[id$=txtlabNo]').val('');
                            $('[id$=txtlabNo]').val('');
                            $('[id$=txtPatientname]').val('');
                            $bindSubCategory(4, 'LSHHI3', function () { });
                            $('[id$=lblItemName]').val('');
                            $('[id$=lblItemName]').text('');
                            $('[id$=txttokenno]').val('');
                        }
                        else {
                            modelAlert('No Record Found..', function () {
                                $('[id$=txtlabNo]').val('');
                                $('[id$=txtlabNo]').val('');
                                $('[id$=txtPatientname]').val('');
                                $bindSubCategory(4, 'LSHHI3', function () { });
                                $('[id$=lblItemName]').val('');
                                $('[id$=lblItemName]').text('');
                                $('#OPDTokenOutput').hide();
                                $('[id$=txttokenno]').val('');
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
            <b>Laboratory Token List</b>
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
                                Lab No.
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <input type="text" id="txtlabNo" />
                        </div>
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
                                Department
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <select id="ddlSubCategory" title="Select SubCategory"></select>
                        </div>
                    </div>
                    <div class="row">
                         <div class="col-md-3">
                            <label class="pull-left">
                              Token No.
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <input type="text" id="txttokenno"  />
                        </div>
                         <div class="col-md-1"></div>
                        <div class="col-md-2">
                            <label class="pull-left">
                                Search
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <input type="text" id="txtSearch" title="Enter Search Text" />
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Item Name
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-10">
                            <label id="lblItemName" title="Enter Search Text"></label>
                        </div>
                    </div>
                    <div class="row" style="text-align: center">
                        <input type="button" id="btnsearch" value="Search" class="itdosebutton" onclick="Search();" />
                    </div>
                </div>
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
            <table cellpadding="0" cellspacing="0" style="width: 100%" id="myTable">
                <tr>
                    <td colspan="4">
                        <div id="OPDTokenOutput" style="max-height: 400px; overflow-x: auto;">
                        </div>
                        <br />
                    </td>
                </tr>
            </table>
        </div>
    </div>
    <script id="tb_SearchToken" type="text/html">
        <table class="FixedTables" cellspacing="0" rules="all" border="1" id="tbl_Laboratory_TokenList"
    style="width:100%;border-collapse:collapse;">
		<tr id="Header">
			<th class="GridViewHeaderStyle" scope="col" style="width:10px;">S.No.</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:80px;">UHID</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:60px;">Lab No.</th>			
            <th class="GridViewHeaderStyle" scope="col" style="width:160px;">Patient Name</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:60px;">Age</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:60px;">Department</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:60px;">Investigation</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:60px;">Date</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:60px;">Token No.</th> 	
            <th class="GridViewHeaderStyle" scope="col" style="width:60px;">Select</th> 	 
            <th class="GridViewHeaderStyle" scope="col" style="width:30px;">Create Token</th> 
            <th class="GridViewHeaderStyle" scope="col" style="width:30px;">Cancel Token</th> 
            <th class="GridViewHeaderStyle" scope="col" style="width:30px;display:none">LedgerTransactionNo</th>  
             <th class="GridViewHeaderStyle" scope="col" style="width:30px;display:none">Test_ID</th>
             <th class="GridViewHeaderStyle" scope="col" style="width:30px;display:none">LabInvestigationOPD_ID</th>
                    
		</tr>
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
                    <td class="GridViewLabItemStyle" id="tdMRNo"  style="width:50px;text-align:center" ><#=objRow.PatientID#></td>
                    <td class="GridViewLabItemStyle" id="tdLabNo" style="width:30px;text-align:center"><#=objRow.LedgerTransactionNo#></td>
                    <td class="GridViewLabItemStyle" id="tdPatientName" style="width:160px;text-align:left"><#=objRow.PName#></td>
                    <td class="GridViewLabItemStyle" id="tdAge" style="width:60px;"><#=objRow.Age#></td>                     
                    <td class="GridViewLabItemStyle" id="tdObservationName" style="width:160px;text-align:left"><#=objRow.ObservationName#></td>
                    <td class="GridViewLabItemStyle" id="tdSampledate"  style="width:160px;text-align:left" ><#=objRow.Name#></td> 
                    <td class="GridViewLabItemStyle" id="tdDoctorname"  style="width:160px;text-align:center" ><#=objRow.DATETIME#></td> 
                    <td class="GridViewLabItemStyle" id="tdtokenNo" style="width:60px; text-align:center;font-size:medium;font:bold;color: green"><#=objRow.tokenNo#></td>
                    <td class="GridViewLabItemStyle" style="width:30px; text-align:center">  
                        <input type="checkbox" id="chkSelect" <# if(objRow.tokenNoExit=="1"&&objRow.IsCancelToken=="0"){#> <#}
                         else if(objRow.tokenNo==""||objRow.IsCancelToken=="3") {#> checked="checked"<#}#> 
                                  <#if(objRow.IsCancelToken=="3"&&objRow.tokenNo!=""){#>
                                    disabled="disabled"<#} else if(objRow.IsCancelToken=="2") {#>  disabled="disabled"<#}#>   />
                        </td>                                                                       
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
                         <td class="GridViewLabItemStyle" id="tdLedgerTransactionNo"  style="width:60px;text-align:center;display:none"><#=objRow.LedgerTransactionNo1#></td> 
                         <td class="GridViewLabItemStyle" id="tdTest_ID"  style="width:60px;text-align:center;display:none"><#=objRow.Test_ID#></td> 
                         <td class="GridViewLabItemStyle" id="tdLabInvestID"  style="width:60px;text-align:center;display:none"><#=objRow.LabInvestigationOPD_ID#></td>
                    </tr>            
        <#}        
        #>      
     </table>
    </script>
</asp:Content>

