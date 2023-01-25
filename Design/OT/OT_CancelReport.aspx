<%@ Page Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="OT_CancelReport.aspx.cs" Inherits="Design_OT_OT_CancelReport" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script src="../../Scripts/Message.js" type="text/javascript"></script>

    <script type="text/javascript">
        $(document).ready(function () {
            $('#txtfromdate').change(function () {
                ChkDate();
            });

            $('#txttodate').change(function () {
                ChkDate();
            });

        });

        function ChkDate() {
            $.ajax({
                url: "../Common/CommonService.asmx/CompareDate",
                data: '{DateFrom:"' + $('#txtfromdate').val() + '",DateTo:"' + $('#txttodate').val() + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    var data = mydata.d;
                    if (data == false) {
                        $('#lblmsg').text('To date can not be less than from date!');
                    }
                    else {
                        $('#lblmsg').text('');
                        $('#btnsubmit').removeAttr('disabled');
                    }
                }
            });
        }
    </script>
    <div id="Pbody_box_inventory">
        <cc1:ToolkitScriptManager ID="sc" runat="server"></cc1:ToolkitScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
           <b> OT Cancel Report </b>
                <br />
            <asp:Label ID="lblmsg" runat="server" CssClass="ItDoseLblError"></asp:Label>
        </div>
        <div class="POuter_Box_Inventory">
             <div class="Purchaseheader">
                Search Criteria
            </div>

           <div class="row">
               <div class="col-md-1"></div>
               <div class="col-md-22">
                     <div class="row">
                          <div class="col-md-3">
                            <label class="pull-left">From Date</label>
                            <b class="pull-right">:</b>
                        </div>
                         <div class="col-md-5">
                              <asp:TextBox ID="txtfromdate" runat="server" ClientIDMode="Static"></asp:TextBox>
                                 <cc1:CalendarExtender ID="todalcal" TargetControlID="txtfromdate" Format="dd-MMM-yyyy" runat="server">
                                 </cc1:CalendarExtender>
                             </div>
                          <div class="col-md-3">
                            <label class="pull-left">To Date </label>
                            <b class="pull-right">:</b>
                        </div>
                         <div class="col-md-5">
                              <asp:TextBox ID="txttodate" runat="server" ClientIDMode="Static"></asp:TextBox>
                                <cc1:CalendarExtender ID="Fromdalcal" TargetControlID="txttodate" Format="dd-MMM-yyyy" runat="server"> </cc1:CalendarExtender>
                             </div>
                         <div class="col-md-3"></div>
                         <div class="col-md-5">
                              <asp:Button ID="btnsubmit" runat="server" Text="Submit" OnClick="btnsubmit_Click" CssClass="ItDoseButton" />
                         </div>
                     </div>
                </div>
               <div class="col-md-1"></div>
           </div>
        </div>
    </div>
</asp:Content>

