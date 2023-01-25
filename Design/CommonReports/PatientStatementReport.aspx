<%@ Page Language="C#" AutoEventWireup="true" CodeFile="PatientStatementReport.aspx.cs" Inherits="Design_CommonReports_PatientStatementReport" MasterPageFile="~/DefaultHome.master" %>


<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
         <div id="Pbody_box_inventory">
          <div class="POuter_Box_Inventory" style="text-align: center">
            <b> Patient Statement Report</b><br />
              <asp:Label runat="server" CssClass="ItDoseLblError" ID="spnMsg" ClientIDMode="Static" ></asp:Label>
        </div>
         <div class="POuter_Box_Inventory" style="text-align: center">
             <div class="row">
                  <div class="col-md-3">
                     <label class="pull-left">Report Type.</label>
                     <b class="pull-right">:</b>
                 </div>
                    <div class="col-md-5">
                        <asp:RadioButtonList ID="rdoReportType" runat="server" RepeatDirection="Horizontal">
                            <asp:ListItem Value="0" Selected="True">Excel</asp:ListItem>
                            <asp:ListItem Value="1">PDF</asp:ListItem>
                        </asp:RadioButtonList>
                    </div>
                 <div class="col-md-3">
                     <label class="pull-left">UHID No.</label>
                     <b class="pull-right">:</b>
                 </div>
                 <div class="col-md-5">
                   <asp:TextBox ID="txtUHIDNo" runat="server" CssClass="requiredField" ToolTip="Please Enter UHID No."></asp:TextBox>
                 </div>
                 </div>
             <div class="row">
                 <div class="col-md-24">
                     <asp:Button ID="btnreport" runat="server" Text="Get Report" OnClick="btnreport_Click" />
                  </div>
             </div>
             </div>
             </div>
    </asp:Content>