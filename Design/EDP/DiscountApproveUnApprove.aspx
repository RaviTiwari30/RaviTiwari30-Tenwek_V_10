<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="DiscountApproveUnApprove.aspx.cs" Inherits="Design_EDP_DiscountApproveUnApprove" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script>

        function ChkDate() {
            $.ajax({
                url: "../common/CommonService.asmx/CompareDate",
                data: '{DateFrom:"' + $('#txtFromDate').val() + '",DateTo:"' + $('#txtToDate').val() + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    var data = mydata.d;
                    if (data == false) {
                        $('#<%=lblMsg.ClientID %>').text('To date can not be less than from date!');
                        $('#btnSearch').attr('disabled', 'disabled');

                    }
                    else {
                        $('#<%=lblMsg.ClientID %>').text('');
                        $('#btnSearch').removeAttr('disabled');
                    }
                }
            });
        }


    </script>
    <div id="Pbody_box_inventory">
        <cc1:ToolkitScriptManager ID="pageScripptManager" runat="server"></cc1:ToolkitScriptManager>

        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Approve Un-Approve Discount</b><br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError"  ClientIDMode="Static" />
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Search Criteria
            </div>
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3" style="display:none">
                            <label class="pull-left">
                                Type
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5" style="display:none">
                            <asp:RadioButtonList ID="rblType" runat="server" ClientIDMode="Static" RepeatDirection="Horizontal">
                                <asp:ListItem Text="OPD" Value="OPD" Selected="True"></asp:ListItem>
                                <asp:ListItem Text="IPD" Value="IPD"></asp:ListItem>
                            </asp:RadioButtonList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                UHID
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <input type="text" id="txtUHID" />
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Bill No.
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <input type="text" id="txtBillNo" />
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Status
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <select id="ddlStatus">
                                <option value="0" selected="selected">Pending</option>
                                <option value="1">Approved</option>
                                <option value="2">Un-Approved</option>
                            </select>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                From Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtFromDate" runat="server" ClientIDMode="Static" onchange="ChkDate()"></asp:TextBox>
                            <cc1:CalendarExtender ID="calFrom" runat="server" TargetControlID="txtFromDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                To Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtToDate" runat="server" ClientIDMode="Static" onchange="ChkDate()"></asp:TextBox>
                            <cc1:CalendarExtender ID="calTo" runat="server" TargetControlID="txtToDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                        </div>
                    </div>
                    <div class="row" style="display:none">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Transaction Type
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                             <asp:RadioButtonList ID="rdbtnxType" runat="server" ClientIDMode="Static" RepeatDirection="Horizontal">
                                <asp:ListItem Text="All" Value="All"></asp:ListItem>
                                <asp:ListItem Text="Discount" Value="Discount"  Selected="True"></asp:ListItem>
                                 <asp:ListItem Text="Refund" Value="Refund"></asp:ListItem>
                            </asp:RadioButtonList>
                        </div>
                        </div>
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="text-align:center;">
            
            <input type="button" value="Search" id="btnSearch" style="width:100px;margin-top:7px;" onclick="Serach()" />
            </div>
        <div class="POuter_Box_Inventory" style="text-align:center;display:none;" id="searchResult">
            <div class="Purchaseheader">
                Search Results
            </div>
            <div class="row" id="DisAppovalOutput" style="max-height:350px;overflow-y:scroll;"></div>
           
        <div class="row" style="text-align:center;">
            <div class="row">
                <div class="col-md-4"></div>
                <div class="col-md-5">
                     <label class="pull-left">
                                Approve/Un-Approve Remark
                            </label>
                            <b class="pull-right">:</b>

                </div>
                <div class="col-md-5">
                    <input type="text" id="txtApprovalRemark" autocomplete="off" onlytext="100" allowCharsCode="47" />
                </div>
                <div class="col-md-9" style="text-align:left">
            <input type="button" value="Approve" style="width:100px;" onclick="ApproveUnapprove(1)" />
            <input type="button" value="Un-Approve" style="width:100px;" onclick="ApproveUnapprove(2)" />
            <input type="button" value="Export" style="width:100px;" onclick="window.open('../../Design/common/ExportToExcel.aspx');"/>
                    </div>
                </div>
        </div>
             </div>
    </div>
    <script>
        var Serach = function () {
            var data = {
                type: $('#rblType').find(':checked').val(),
                uhid: $.trim($('#txtUHID').val()),
                billNo: $.trim($('#txtBillNo').val()),
                status: $('#ddlStatus').val(),
                fromDate: $.trim($('#txtFromDate').val()),
                toDate: $.trim($('#txtToDate').val()),
                tnxType: $('#rdbtnxType').find(':checked').val(),
            };

            serverCall('DiscountApproveUnApprove.aspx/Search', data, function (response) {
                if (response != '') {
                    DisAppoval = JSON.parse(response);
                    var output = $('#tb_DisAppovalSearch').parseTemplate(DisAppoval);
                    $('#DisAppovalOutput').html(output).customFixedHeader();
                    $('#searchResult').show();
                    $('#lblMsg').text(DisAppoval.length + ' Records Found');
                }
                else {
                    $('#searchResult').hide();
                    $('#DisAppovalOutput').empty();
                    $('#lblMsg').text('No Record Found');
                }


            });


        }

        var checkAll = function (sender) {
            if ($(sender).prop('checked'))
                $('[id$=cbApprove]').prop('checked', true);
            else
                $('[id$=cbApprove]').prop('checked', false);
        }
        var ApproveUnapprove = function (type) {
            var data = [];
            $('#tb_grdDisAppovalSearch tr:not(#Header)').each(function () {
                if ($(this).find('#cbApprove').prop('checked')) {
                    data.push({
                        dataType: $(this).find('#tdType').text(),
                        billNo: $(this).find('#tdBillNo').text(),
                        updateType: type,
                        remark: $.trim($('#txtApprovalRemark').val())
                    });

                }
            });

            if (data.length == 0) {
                modelAlert('Please Select Atleast One Record to Update');
                return false;
            }
            modelConfirmation('Confirm!!!', 'Do You Want To Update Status ?', 'Update', 'Close', function (response) {
                if (response) {
                    serverCall('DiscountApproveUnApprove.aspx/ApproveUnapprove', { dataList: data }, function (response) {
                        var responseData = JSON.parse(response);
                        modelAlert(responseData.response, function () {
                            if (responseData.status)
                                location.reload();

                        });


                    });
                }
            });

        }
    </script>
             <script id="tb_DisAppovalSearch" type="text/html">
    <table class="FixedTables" cellspacing="0" rules="all" border="1" id="tb_grdDisAppovalSearch" style="width:100%;border-collapse:collapse;">
		<tr id="Header">
			<th class="GridViewHeaderStyle" scope="col" style="width:10px;">Type</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:50px;">TnxType</th>
            <th class="GridViewHeaderStyle" scope="col">UHID</th>
            <th class="GridViewHeaderStyle" scope="col">Bill No</th>
            <th class="GridViewHeaderStyle" scope="col">Bill Date</th>
            <th class="GridViewHeaderStyle" scope="col">Patient Name</th> 
            <th class="GridViewHeaderStyle" scope="col">Age</th>
            <th class="GridViewHeaderStyle" scope="col">Contact No</th>
            <th class="GridViewHeaderStyle" scope="col">Gross Amt</th>
            <th class="GridViewHeaderStyle" scope="col">Disc. Amt</th>
            <th class="GridViewHeaderStyle" scope="col">Net Amt</th>
            <th class="GridViewHeaderStyle" scope="col">Disc/Refund Given By</th>
            <th class="GridViewHeaderStyle" scope="col">Disc/Refund Reason</th>
            <th class="GridViewHeaderStyle" scope="col">Disc/Refund App. By</th>
            <th class="GridViewHeaderStyle" scope="col">Status</th>
            <th class="GridViewHeaderStyle" scope="col">Approved By</th>
            <th class="GridViewHeaderStyle" scope="col">App. Remarks</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:10px;"><input type="checkbox" onclick="checkAll(this)" /></th>
		</tr>
        <#       
        var dataLength=DisAppoval.length;
        window.status="Total Records Found :"+ dataLength;
        var objRow;   
        var status;     
        for(var j=0;j<dataLength;j++)
        {       
        objRow = DisAppoval[j];
        #>
                    <tr id="<#=j+1#>">                            
                    <td class="GridViewLabItemStyle" id="tdType"><#=objRow.Type#></td>
                    <td class="GridViewLabItemStyle" id="td1"><#=objRow.TnxType#></td>
                    <td class="GridViewLabItemStyle"><#=objRow.UHID#></td>
                    <td class="GridViewLabItemStyle" id="tdBillNo"><#=objRow.BillNo#></td>
                    <td class="GridViewLabItemStyle"><#=objRow.BillDate#></td>
                    <td class="GridViewLabItemStyle"><#=objRow.PName#></td>
                    <td class="GridViewLabItemStyle"><#=objRow.Age#></td>
                    <td class="GridViewLabItemStyle"><#=objRow.Mobile#></td>
                    <td class="GridViewLabItemStyle"><#=objRow.GrossAmount#></td>
                    <td class="GridViewLabItemStyle"><#=objRow.DiscAmt#></td>
                    <td class="GridViewLabItemStyle"><#=objRow.NetAmount#></td>
                    <td class="GridViewLabItemStyle"><#=objRow.DiscUser#></td>
                    <td class="GridViewLabItemStyle"><#=objRow.DiscountReason#></td>
                    <td class="GridViewLabItemStyle"><#=objRow.DiscountApproveBy#></td>
                    <td class="GridViewLabItemStyle"><#=objRow.Status#></td>
                    <td class="GridViewLabItemStyle"><#=objRow.UpdatedBy#></td>
                    <td class="GridViewLabItemStyle"><#=objRow.Remarks#></td>
                    <td class="GridViewLabItemStyle">
                        <#if(objRow.Status=='Pending'){#>
                        <input type="checkbox" id="cbApprove" />
                        <#}#>
                    </td>
 </tr>           
        <#}#>                     
     </table>    
    </script>
</asp:Content>

