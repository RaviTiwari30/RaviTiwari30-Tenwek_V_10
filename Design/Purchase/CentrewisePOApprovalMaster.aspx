<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="CentrewisePOApprovalMaster.aspx.cs" Inherits="Design_Purchase_CentrewisePOApprovalMaster" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <script type="text/javascript">

        $(document).ready(function () {
            $bindCentre(function () {
                $BindPoApprovalMaster(function () { });
            });

        });

        var $bindCentre = function (callback) {
            serverCall('Services/CentrewisePOApproval.asmx/BindCentre', {}, function (response) {
                $Centre = $('#ddlCentre');
                $Centre.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'CentreID', textField: 'CentreName', isSearchAble: true, selectedValue: 'Select' });
                $bindEmployee(function () {
                    callback($Centre.find('option:selected').text());
                });
            });
        }
        var $bindEmployee = function (callback) {
            var CentreId = $('#ddlCentre').val();
            serverCall('Services/CentrewisePOApproval.asmx/bindEmployee', { centreId: CentreId }, function (response) {
                $Employee = $('#ddlEmployee');
                $Employee.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'EmployeeID', textField: 'EmployeeName', isSearchAble: true, selectedValue: 'Select' });
                callback($Employee.find('option:selected').text());
            });
        }

        var $BindPoApprovalMaster = function (callback) {
            serverCall('Services/CentrewisePOApproval.asmx/BindApprovalMaster', {}, function (response) {
                templateData = JSON.parse(response);
                var html = $('#templateApprovalMaster').parseTemplate(templateData);
                $('#dvApprovalMaster').html(html);
                $('#dvList').show();
            });
        }
        var $DeleteRow = function (selectedRowId,callback) {
            serverCall('Services/CentrewisePOApproval.asmx/deleteApprovalMaster', { Id: selectedRowId }, function (response) {
                $responseData = JSON.parse(response);
                modelAlert($responseData.response, function (response) {
                    if ($responseData.status) {
                        $BindPoApprovalMaster();
                    }
                });
            });
        }
        var $savePoApprovalMaster = function (callback)
        {
            debugger;
            $('#lblMsg').text('');
            if ($('#ddlCentre').val() == "0") {
                $('#lblMsg').text('Please Select Centre');
                $('#ddlCentre').focus();
                return false;
            }

            if ($('#ddlEmployee').val() == "0") {
                $('#lblMsg').text('Please Select Employee');
                $('#ddlEmployee').focus();
                return false;
            }
            if (Number($('#txtToAmount').val()) <=0) {
                $('#lblMsg').text('Please Valid From Amount');
                $('#txtToAmount').focus();
                return false;
            }

            if(Number($('#txtFromAmount').val())>Number($('#txtToAmount').val()))
            {
                $('#lblMsg').text('To Amount should be greater than From Amount');
                $('#txtToAmount').focus();
                return false;
            }

            var categoryId= "";

            $("#chkCategory input[type=checkbox]") .each(function(i,e) {
            
                if($(e).attr("checked"))
                {
                    if(categoryId == "")
                        categoryId = $(e).val();
                    else
                        categoryId += ","+ $(e).val();
                }
            });

            if (categoryId == "")
            {
                $('#lblMsg').text('Please Select Atleast One Category');
                return false;
            }

            $('#btnSave').attr('disabled', true).val('Submitting...');
            
            $ApprovalData = [];
            $ApprovalData.push({
                EmployeeId: $('#ddlEmployee').val(),
                FromAmount: Number($('#txtFromAmount').val()),
                ToAmount: Number($('#txtToAmount').val()),
                CategoryId: categoryId,
                CentreId: Number($('#ddlCentre').val()),
            });

            serverCall('Services/CentrewisePOApproval.asmx/saveApprovalMaster', { PoApproval: $ApprovalData }, function (response) {
                $responseData = JSON.parse(response);
                modelAlert($responseData.response, function (response) {
                    if ($responseData.status) {
                        $BindPoApprovalMaster();
                    }
                    $('#btnSave').removeAttr('disabled').val('Save');
                });
            });
        }

    </script>

    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Centre Wise Employee Approval Setting </b>
            <br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" ClientIDMode="Static" />
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Details
            </div>
            <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">
                        Centre Name 
                    </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:DropDownList ID="ddlCentre" runat="server" onchange=" $bindEmployee(function () {});" CssClass="required" ClientIDMode="Static" TabIndex="1" ToolTip="Select Centre"></asp:DropDownList>
                </div>
                <div class="col-md-3">
                    <label class="pull-left">
                        Employee Name
                    </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:DropDownList ID="ddlEmployee" runat="server" ClientIDMode="Static" CssClass="required" TabIndex="2" ToolTip="Select Employee"></asp:DropDownList>
                </div>

                <div class="col-md-3">
                    <label class="pull-left">
                      
                    </label>
                    <b class="pull-right"></b>
                </div>
                <div class="col-md-5">
                   
                </div>
            </div>
             <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">
                        From Amount
                    </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                 <input id="txtFromAmount" onlynumber="13" decimalplace="3" max-value="1000000000" tabindex="3" class="requiredField ItDoseTextinputNum" type="text" />
                </div>
                <div class="col-md-3">
                    <label class="pull-left">
                        To Amount
                    </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                   <input id="txtToAmount" onlynumber="13" decimalplace="3" max-value="1000000000" tabindex="4" class="requiredField ItDoseTextinputNum" type="text" />
                 </div>

                <div class="col-md-3">
                    <label class="pull-left">
                     
                    </label>
                    <b class="pull-right"></b>
                </div>
                <div class="col-md-5">
                   
                </div>
            </div>
             <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">
                        Category 
                    </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-21">
                   <asp:CheckBoxList ID="chkCategory" runat="server" ClientIDMode="Static" CssClass="required" TabIndex="5" ToolTip="Select Category"></asp:CheckBoxList>
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-24 textCenter">
                    <input type="button" id="btnSave" onclick="$savePoApprovalMaster()" class="save" value="Save" tabindex="6" />
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory" id="dvList" style="display: none;">
            <div class="Purchaseheader">
                Approval Master List
            </div>
            <div class="row">
                <div class="col-md-24" style="text-align: center;">
                    <div id="dvApprovalMaster"></div>
                </div>
            </div>
        </div>
    </div>

      <script id="templateApprovalMaster" type="text/html">
        <table  id="tableApprovalMaster" cellspacing="0" rules="all" border="1" style="width:100%;border-collapse :collapse;">
            <thead>
                <tr id="TrHeader">
                    <th class="GridViewHeaderStyle" scope="col"style="text-align:center;width: 10px;"  >S/No.</th>
                    <th class="GridViewHeaderStyle" scope="col" style="text-align:center;">Centre Name</th>
                    <th class="GridViewHeaderStyle" scope="col" style="text-align:center;">Employee Name</th>
                    <th class="GridViewHeaderStyle" scope="col" style="text-align:center;">Entry Date</th>
                    <th class="GridViewHeaderStyle" scope="col" style="text-align:center;">Entry By</th>
                    <th class="GridViewHeaderStyle" scope="col" style="text-align:center;">From Amount</th>
                    <th class="GridViewHeaderStyle" scope="col" style="text-align:center;">To Amount</th>
                    <th class="GridViewHeaderStyle" scope="col" style="text-align:center;">Category</th>
                    <th class="GridViewHeaderStyle" scope="col" style="text-align:center;">Delete</th>
                </tr>
            </thead>
            <tbody>
            <#                       
                var dataLength=templateData.length;
                for(var j=0;j<dataLength;j++)
                {           
                    var objRow = templateData[j];
            #>              
                <tr onmouseover="this.style.color='#00F'" onMouseOut="this.style.color=''" id="<#=j+1#>" >                                                       
                    <td  class="GridViewLabItemStyle" style="text-align:center;width: 10px;" ><#=j+1#></td>
                    <td class="GridViewLabItemStyle" style="text-align:left;" ><#=objRow.CentreName#></td>
                    <td class="GridViewLabItemStyle"  style="text-align:left;" ><#=objRow.EmployeeName#></td>
                    <td class="GridViewLabItemStyle" style="text-align:center;" ><#=objRow.EntryDate#></td>
                    <td class="GridViewLabItemStyle" style="text-align:left;" ><#=objRow.EntryBy#></td>
                    <td class="GridViewLabItemStyle" style="text-align:center;" ><#=objRow.FromAmount#></td>
                    <td class="GridViewLabItemStyle" style="text-align:center;" ><#=objRow.ToAmount#></td>
                    <td class="GridViewLabItemStyle" style="text-align:left;" ><#=objRow.CategoryName#></td>
                    <td class="GridViewLabItemStyle" style="width:5px;">
                     <img alt="" src="../../Images/Delete.gif" class="imgPlus" title="Delete Row" style="cursor:pointer" onclick="$DeleteRow('<#=objRow.Id#>')"  /></td>                 
                </tr>  
                   
           
            <#}#>
            </tbody>      
        </table>
         </script>

</asp:Content>

