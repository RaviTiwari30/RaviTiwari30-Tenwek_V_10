<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="DoctorWiseTokenDisplay.aspx.cs" Inherits="Design_DoctorScreen_DoctorWiseTokenDisplay" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
       <script type="text/javascript" src="../../Scripts/CheckboxSearch.js"></script>
      <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">

            <b><span id="lblHeader">Doctor Wise Token Display</span></b>
            <br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError"></asp:Label>

        </div>
        <div class="POuter_Box_Inventory">
            <div class="row">
               <div class="col-md-22"> 
                   <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                <b>Search By Name</b>
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                             <input id="txtSearch" onkeyup="SearchCheckbox(this,cblUser)" style="width: 300px" />
                        </div>
                       </div>
                </div>
        </div>
              <div class="row" style="max-height:450px; overflow:scroll">
               <div class="col-md-22"> 
                   <div class="row">
                        <div class="col-md-3">
                            <asp:CheckBox ID="chkuser" runat="server" AutoPostBack="false" Text="Select Doctors" Checked="false"
                                CssClass="ItDoseCheckbox" />
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-19; scrollankur"  style="text-align: left">
                             <asp:CheckBoxList ID="cblUser" CssClass="ItDoseCheckbox" Font-Size="8" runat="server" ClientIDMode="Static"
                                    RepeatDirection="Horizontal" RepeatLayout="Table" RepeatColumns="5" />
                        </div>
                       </div>
                </div>
            </div>
            <div class="row">
               <div class="col-md-22" > 
                   <div class="row">
                         <div class="col-md-22" style="text-align:center">                            
                              <asp:Button ID="btnPreview" runat="server" Text="Display" CssClass="ItDoseButton" OnClick="btnPreview_Click" ClientIDMode="Static" />
                        </div>
                   </div>
                </div>
            </div>
    </div>
</div>
    <script type="text/jscript">

        $(function () {
            $("[id*=chkuser]").bind("click", function () {
                if ($(this).is(":checked")) {
                    $("[id*=cblUser] input").attr("checked", "checked");
                } else {
                    $("[id*=cblUser] input").removeAttr("checked");
                }
            });
        });

    </script>
</asp:Content>

