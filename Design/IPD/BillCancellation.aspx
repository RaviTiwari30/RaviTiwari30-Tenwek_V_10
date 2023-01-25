<%@ Page Language="C#" AutoEventWireup="true" CodeFile="BillCancellation.aspx.cs" Inherits="Design_IPD_BillCancellation" MasterPageFile="~/DefaultHome.master" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" ID="Content1" runat="server">
    <script type="text/javascript">
        $(function () {
            $("#rblType input[type=radio]").click(function () {
                chkType();
            });
        });
        function chkType() {
            $('#BillSearchOutput,#divDetail,#divCancelBill,#pnlHide').hide();
            $('#BillSearchOutput').html('');
            $('#lblMsg').text('');
        }

    </script>
    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="sc" runat="server"></Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>IPD Bill Cancellation</b><br />


            <div style="text-align: center; width: 100%;">
                <table style="width: 100%; text-align: center">
                    <tr>
                        <td style="width: 42%">&nbsp;
                        </td>
                        <td>


                            <asp:RadioButtonList ID="rblType" onclick="chkType" runat="server" ClientIDMode="Static" RepeatDirection="Horizontal" RepeatColumns="2"  >
                                <asp:ListItem Value="1" Text="Bill" ></asp:ListItem>
                                <asp:ListItem Value="2" Text="Bill Finalised" Selected="True"></asp:ListItem>
                            </asp:RadioButtonList></td>
                    </tr>
                </table>
            </div>
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" ClientIDMode="Static" />&nbsp;      
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Search Criteria&nbsp;
            </div>
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                UHID 
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtPatientID" runat="server" ClientIDMode="Static" AutoCompleteType="Disabled" MaxLength="20"></asp:TextBox>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                IPD No.
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtIPDNo" runat="server" ClientIDMode="Static" AutoCompleteType="Disabled" MaxLength="10"></asp:TextBox>
                           
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Patient Name
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtPName" ClientIDMode="Static" runat="server" AutoCompleteType="Disabled" MaxLength="20"></asp:TextBox>
                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
           
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <input type="button" class="ItDoseButton" value="Search" onclick="Search()" />

        </div>

        <div class="POuter_Box_Inventory" style="text-align: center; display: none" id="divDetail">
            <div class="Purchaseheader">
                Result Details &nbsp;
            </div>
            <div id="BillSearchOutput" style="max-height: 500px; overflow-x: auto;">
            </div>
        </div>
        <asp:Panel ID="pnlHide" Style="display: none" ClientIDMode="Static" runat="server" Width="750px">
            <div class="POuter_Box_Inventory" style="text-align: center;">

               <div class="row">
                   <div class="col-md-1">
                             </div>
                <div class="col-md-23">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                            Bill No.
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                          <asp:Label ID="lblBillNo" ClientIDMode="Static" runat="server" CssClass="ItDoseLabelSp"></asp:Label>
                            <asp:Label ID="lblTransactionId" ClientIDMode="Static" runat="server" Style="display: none" CssClass="ItDoseLabelSp"></asp:Label>
                            <asp:Label ID="lblPatientID" ClientIDMode="Static" runat="server" Style="display: none" CssClass="ItDoseLabelSp"></asp:Label></td>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                            Total Amount
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-3">
                         <asp:Label ID="lblAmount" ClientIDMode="Static" CssClass="ItDoseLabelSp" runat="server"></asp:Label>
                        </div>
                        <div class="col-md-4">
                            <label class="pull-left">
                            Reason&nbsp;of&nbsp;Cancellation
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                          <asp:TextBox ID="txtReason" Width="95%" ClientIDMode="Static" runat="server"  MaxLength="50" CssClass="requiredField"></asp:TextBox>
                        </div>
                         <div class="col-md-1">
                             </div>
                    </div>
                </div>
                
            </div>

              
            </div>
        </asp:Panel>
        <div class="POuter_Box_Inventory" style="text-align: center; display: none" id="divCancelBill">
            <input type="button" value="Cancel Bill" id="btnCancel" class="ItDoseButton" onclick="cancelBill()" />
        </div>
    </div>
    <script type="text/javascript">
        function Search() {
            if (($.trim($("#txtPatientID").val()) == "") && ($.trim($("#txtIPDNo").val()) == "") && ($.trim($("#txtPName").val()) == "")) {
                $("#lblMsg").text('Please Enter Any One Search Criteria');
                $("#txtPatientID").focus();
                return false;
            }
            else {
                $.ajax({
                    url: "BillCancellation.aspx/BillCancellationSearch",
                    data: '{PatientID:"' + $('#txtPatientID').val() + '",TransactionNo:"' + $('#txtIPDNo').val() + '",PName:"' + $('#txtPName').val() + '",searchType:"' + $("#rblType input[type=radio]:checked").val() + '"}',
                    type: "POST",
                    dataType: "json",
                    contentType: "application/json; charset=utf-8",
                    success: function (mydata) {
                        searchData = jQuery.parseJSON(mydata.d);
                        if (searchData != null) {
                            var output = $('#tb_SearchBill').parseTemplate(searchData);
                            $('#BillSearchOutput').html(output);
                            $('#BillSearchOutput,#divDetail').show();
                            $("#<%=lblMsg.ClientID%>").text('');
                        }
                        else {
                            $('#BillSearchOutput').html('');
                            $('#BillSearchOutput,#divDetail,#divCancelBill').hide();
                            $("#<%=lblMsg.ClientID%>").text('Record Not Found');

                        }
                    },

                    error: function (xhr, status) {
                        $("#<%=lblMsg.ClientID%>").text('Error occurred, Please contact administrator');
                    }
                });
                }
            }
    </script>
    <script id="tb_SearchBill" type="text/html">
    <table class="FixedTables" cellspacing="0" rules="all" border="1" id="tb_grdSearch"
    style="width:100%;border-collapse:collapse;">
		<tr id="Header">
			<th class="GridViewHeaderStyle" scope="col" style="width:10px;">S.No.</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:200px;">Patient Name</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:120px;">UHID</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:40px;">IPD No.</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:120px;">Bill No.</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:120px;">Total Bill</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:120px;display:none">TransactionID</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:40px;">Select</th>
           
		</tr>
        <#
        var dataLength=searchData.length;
        window.status="Total Records Found :"+ dataLength;
        var objRow;
        for(var j=0;j<dataLength;j++)
        {
        objRow = searchData[j];
        #>
                    <tr id="<#=j+1#>">
                    <td class="GridViewLabItemStyle"><#=j+1#></td>
                    <td class="GridViewLabItemStyle" id="tdPName"  style="width:200px;text-align:center" ><#=objRow.PName#></td>
                    <td class="GridViewLabItemStyle" id="tdPatientID"  style="width:120px;text-align:center" ><#=objRow.PatientID#></td>
                    <td class="GridViewLabItemStyle" id="tdIPDNo" style="width:40px;"><#=objRow.IPDNo#></td>
                    <td class="GridViewLabItemStyle" id="tdBillNo" style="width:120px;"><#=objRow.BillNo#></td>
                    <td class="GridViewLabItemStyle" id="tdTotalBilledAmt" style="width:120px;"><#=objRow.TotalBilledAmt#></td>
                    <td class="GridViewLabItemStyle" id="tdTransactionID" style="width:80px;display:none"><#=objRow.TransactionID#></td>
                   
                    <td class="GridViewLabItemStyle" id="tdDocAmt"  style="width:40px;text-align:right">
                        <img src="../../Images/Post.GIF" style="cursor:pointer" onclick="showDetail(this)" />
                    </td>
                   
                    </tr>

        <#}

        #>
        
     </table>
    </script>
    <script type="text/javascript">
        function showDetail(rowID) {
            
            var TID=$(rowID).closest('tr').find("#tdTransactionID").text();

            serverCall('BillCancellation.aspx/CheckDataInFinance', {TID:TID}, function (response) {
                var responseData = JSON.parse(response)
                if (responseData.status) {
                    modelAlert(responseData.message);
                }
                else {
                    $("#lblBillNo").text($(rowID).closest('tr').find("#tdBillNo").text());
                    $("#lblTransactionId").text($(rowID).closest('tr').find("#tdTransactionID").text());
                    $("#lblPatientID").text($(rowID).closest('tr').find("#tdPatientID").text());
                    $("#lblAmount").text($(rowID).closest('tr').find("#tdTotalBilledAmt").text());
                    $("#divCancelBill,#pnlHide").show();
                    $("#txtReason").focus();

                }
            });
           
        }
    </script>
    <script type="text/javascript">
        function cancelBill() {
            if ($.trim($("#txtReason").val()) != "") {
                $("#btnCancel").attr('disabled', 'disabled').val("Submitting...");
                $.ajax({
                    url: "BillCancellation.aspx/billCancel",
                    data: '{PatientID:"' + $('#lblPatientID').text() + '",TransactionNo:"' + $('#lblTransactionId').text() + '",BillNo:"' + $('#lblBillNo').text() + '",searchType:"' + $("#rblType input[type=radio]:checked").val() + '",Reason:"' + $("#txtReason").val() + '"}',
                    type: "POST",
                    dataType: "json",
                    contentType: "application/json; charset=utf-8",
                    success: function (mydata) {
                        if (mydata.d == "2")
                            $("#<%=lblMsg.ClientID%>").text('Patient Invoice No. has been Dispatched');
                        else if (mydata.d == "1")
                            $("#<%=lblMsg.ClientID%>").text('Record Saved Successfully');
                        else if (mydata.d == "3") {
                            modelAlert(' Patient Final Bill Already Posted To Finance...');
                            $("#btnCancel").attr('disabled', false).val("Cancel Bill");
                            return;
                        }
                        else
                            $("#<%=lblMsg.ClientID%>").text('Error occurred, Please contact administrator');
                        $("#txtReason").val('');
                        $("#lblBillNo,#lblTransactionId,#lblPatientID,#lblAmount").text('');
                        $('#BillSearchOutput').html('');
                        $('#BillSearchOutput,#divDetail,#divCancelBill,#pnlHide').hide();
                        $("#btnCancel").attr('disabled', false).val("Cancel Bill");
                    },
                    error: function (xhr, status) {
                        $("#<%=lblMsg.ClientID%>").text('Error occurred, Please contact administrator');
                    }

                });
                }
                else {
                    $("#<%=lblMsg.ClientID%>").text('Please Enter Cancel Reason');
                $("#txtReason").focus();
            }
        }
    </script>
</asp:Content>
