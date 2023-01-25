<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="CreateRadiologyToken.aspx.cs" Inherits="Design_Token_CreateRadiologyToken" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript">
        $(document).ready(function () {
            tokenSearch();
            $bindSubCategory(4, 'LSHHI7', function () { });
            $onInit();
        });
        window.setInterval(function () {
            tokenSearch();
        }, 15000);
        function tokenSearch() {
            $.ajax({
                type: "POST",
                url: "CreateRadiologyToken.aspx/SearchToken",
                data: '{}',
                dataType: "json",
                contentType: "application/json;charset=UTF-8",
                async: true,
                success: function (response) {
                    token = jQuery.parseJSON(response.d);
                    if (token != null) {
                        var output = $('#tb_SearchToken').parseTemplate(token);
                        $('#OPDTokenOutput').html(output).customFixedHeader();
                        //$('#OPDTokenOutput').html(output);
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
            var LedgerTransactionNo = $(rowid).closest('tr').find('#tdLedgerNo').text();
            var Type = $(rowid).closest('tr').find('#tdType').text();
            var ObservationID = $(rowid).closest('tr').find('#tdObservationType_Id').text();
            var Investigation_Id = $(rowid).closest('tr').find('#tdInvestigation_Id').text();
            var LabInvestID = $(rowid).closest('tr').find('#tdLabInvestigationID').text();
            var PatientID = $(rowid).closest('tr').find('#tdPatientID').text();
            $.ajax({
                type: "POST",
                url: "CreateRadiologyToken.aspx/createToken",
                data: '{LedgerTransactionNo:"' + LedgerTransactionNo + '",Type:"' + Type + '",ObservationID:"' + ObservationID + '",Investigation_Id:"' + Investigation_Id + '",LabInvestID:"' + LabInvestID + '",PatientID:"' + PatientID + '"}',
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
            var LabInvestID = $(rowid).closest('tr').find('#tdLabInvestigationID').text();
            var Type = $(rowid).closest('tr').find('#tdType').text();
            $.ajax({
                type: "POST",
                url: "CreateRadiologyToken.aspx/CancelToken",
                data: '{LabInvestID:"' + LabInvestID + '",Type:"' + Type + '"}',
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
                    $categoryID = 'LSHHI7';
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

        $bindSubCategory = function (labItem, categoryID, callback) {
            $subCategory = $('#ddlSubCategory');
            serverCall('CreateRadiologyToken.aspx/BindDepartment', {}, function (response) {
                $subCategory.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'ObservationType_ID', textField: 'Name', isSearchAble: true });
                callback($subCategory.val());
            });
        }

        function Search() {
            var Type = $('[id$=rdbLabType] input:checked').val();
            var PatientName = $('[id$=txtPatientname]').val();
            var DepartmentId = $('[id$=ddlSubCategory]').val();
            var DoctorName = $('[id$=txtdoctorname]').val();
            var labNo = $('[id$=txtlabNo]').val();
            var TokenNo = $('[id$=txttokenno]').val();
            if (labNo == "" && Type == "" && DepartmentId == "0" && InvestigationId == "") {
                modelAlert('Please Select Department..', function () {
                    return false;
                });
            }
            else {
                $.ajax({
                    type: "POST",
                    url: "CreateRadiologyToken.aspx/SearchTokenNumber",
                    data: '{Type:"' + Type + '",PatientName:"' + PatientName + '",DepartmentId:"' + DepartmentId + '",labNo:"' + labNo + '",DoctorName:"' + DoctorName + '",TokenNo:"' + TokenNo + '" }',
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
                            $('[id$=txttokenno]').val('');
                            $('[id$=txtPatientname]').val('');
                            $bindSubCategory(4, 'LSHHI7', function () { });
                        }
                        else {
                            modelAlert('No Record Found..', function () {
                                $('[id$=txtlabNo]').val('');
                                $('[id$=txttokenno]').val('');
                                $('[id$=txtPatientname]').val('');
                                $bindSubCategory(4, 'LSHHI7', function () { });
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
            <b>Radiology Token List</b>
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
                        <div class="col-md-1"></div>
                        <div class="col-md-2">
                            <label class="pull-left">
                                Type
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:RadioButtonList ID="rdbLabType" runat="server" RepeatDirection="Horizontal">
                                <asp:ListItem Text="All" Value="All" Selected="True"></asp:ListItem>
                                <asp:ListItem Text="OPD" Value="OPD" ></asp:ListItem>
                                <asp:ListItem Text="IPD" Value="IPD"></asp:ListItem>
                            </asp:RadioButtonList>
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
                                Doctor Name
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <input type="text" id="txtdoctorname" />
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Department
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                          <select id="ddlSubCategory" title="Select SubCategory"></select>
                        </div>
                              <div class="col-md-1"></div>
                        <div class="col-md-2">
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
                               Token No.
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                               <input type="text" id="txttokenno" />
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
            <th class="GridViewHeaderStyle" scope="col" style="width:50px;">Type</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:80px;">UHID</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:90px;">IPD No.</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:60px;">Lab No.</th>			
            <th class="GridViewHeaderStyle" scope="col" style="width:160px;">Patient Name</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:60px;">Age</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:60px;">Investigation</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:60px;">Date</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:60px;">Doctor</th>	
            <th class="GridViewHeaderStyle" scope="col" style="width:60px;">Token No.</th> 		 
            <th class="GridViewHeaderStyle" scope="col" style="width:30px;">Create Token</th> 
            <th class="GridViewHeaderStyle" scope="col" style="width:30px;">Cancel Token</th> 
            <th class="GridViewHeaderStyle" scope="col" style="width:30px;display:none">LabInvestigation_ID</th>  
            <th class="GridViewHeaderStyle" scope="col" style="width:30px;display:none">ObservationType_Id</th> 
             <th class="GridViewHeaderStyle" scope="col" style="width:30px;display:none">LedgerTransactionNo</th> 
              <th class="GridViewHeaderStyle" scope="col" style="width:30px;display:none">tdInvestigation_Id</th> 
                   
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
                    <td class="GridViewLabItemStyle" id="tdType"  style="width:50px;text-align:center" ><#=objRow.Type#></td>
                    <td class="GridViewLabItemStyle" id="tdPatientID"  style="width:80px;text-align:center" ><#=objRow.PatientID#></td>
                    <td class="GridViewLabItemStyle" id="tdMRNo"  style="width:50px;text-align:center;">
                        <#if(objRow.Type=="OPD"){#><#} else{#><#=objRow.TransactionID#><#}#></td>
                    <td class="GridViewLabItemStyle" id="tdLabNo" style="width:30px;text-align:center"><#=objRow.LTD#></td>
                    <td class="GridViewLabItemStyle" id="tdPatientName" style="width:160px;text-align:left"><#=objRow.pname#></td>
                    <td class="GridViewLabItemStyle" id="tdAge" style="width:60px;"><#=objRow.age#></td>                     
                    <td class="GridViewLabItemStyle" id="tdObservationName" style="width:160px;text-align:left"><#=objRow.ObservationName#></td>
                    <td class="GridViewLabItemStyle" id="tdSampledate"  style="width:160px;text-align:center" ><#=objRow.SampleDate#></td> 
                    <td class="GridViewLabItemStyle" id="tdDoctorname"  style="width:160px;text-align:left" ><#=objRow.DName#></td> 
                    <td class="GridViewLabItemStyle" id="tdtokenNo" style="width:60px; text-align:center;font-size:medium;font:bold;color: green"><#=objRow.tokenNo#></td>                                                                       
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
                         <td class="GridViewLabItemStyle" id="tdLabInvestigationID"  style="width:160px;text-align:center;display:none"><#=objRow.LabInvestigation_ID#></td> 
                         <td class="GridViewLabItemStyle" id="tdObservationType_Id"  style="width:160px;text-align:center;display:none"><#=objRow.ObservationType_Id#></td>
                         <td class="GridViewLabItemStyle" id="tdLedgerNo"  style="width:160px;text-align:center;display:none"><#=objRow.LedgerTransactionNo#></td>
                         <td class="GridViewLabItemStyle" id="tdInvestigation_Id"  style="width:160px;text-align:center;display:none"><#=objRow.Investigation_Id#></td>
                    </tr>            
        <#}        
        #>    
            </tbody>  
     </table>
    </script>
</asp:Content>

