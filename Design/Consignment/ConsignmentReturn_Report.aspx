<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ConsignmentReturn_Report.aspx.cs"
    MasterPageFile="~/DefaultHome.master" Inherits="Design_Consignment_Reports_ConsignmentReturn_Report" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
 <%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="~/Design/Purchase/EntryDate.ascx" TagName="EntryDate" TagPrefix="uc1" %>
<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" ID="Content1" runat="server">

    <script type="text/javascript" language="javascript">

function calltoPopup()
{
//var p1 = 'scrollbars=no,resizable=no,status=no,location=no,toolbar=no,menubar=no'
//	var p2 = 'width=100,height=100,left=100,top=100'
//	window.open('consignmentReturnReport.aspx', 'test', p1+p2)
	
	var win = open('/', 'example', 'width=300,height=300')
win.focus()
win.onload = function() {
  var div = win.document.createElement('div') 
  div.innerHTML = 'Welcome into the future!'
  div.style.fontSize = '30px'
  win.document.body.insertBefore( div, win.document.body.firstChild ) 
  }
	
}




function ButtonDisable(btn)
{
 
 var narration=document.getElementById("ctl00$ContentPlaceHolder1$txtNarration").value;  
 
 if(narration!='')
 {
 btn.disabled = true; 
 __doPostBack('ctl00$ContentPlaceHolder1$btnSave');
 }

}
 function LTrim( value ) {
	
	var re = /\s*((\S+\s*)*)/;
	return value.replace(re, "$1");
	
}
  function RTrim( value ) {
	
	var re = /((\s*\S+)*)\s*/;
	return value.replace(re, "$1");
	
}

// Removes leading and ending whitespaces
function trim( value ) {
	
	return LTrim(RTrim(value));
	
}





function MoveUpAndDownText(textbox2,listbox2)
{

var f = document.theSource;
var listbox = listbox2;
var textbox = textbox2;
if(event.keyCode=='38' ||event.keyCode=='40')
{
if(event.keyCode=='40')
{
for ( var m = 0; m < listbox.length; m++ )
{
if ( listbox.options[m].selected==true ) 
{
if ( m+1==listbox.length ) 
{
return;
}
listbox.options[m+1].selected = true;
textbox.value=listbox.options[m+1].text;

return;
}
}

listbox.options[0].selected=true;
}
if(event.keyCode=='38')
{
for ( var m = 0; m < listbox.length; m++ )
{
if ( listbox.options[m].selected==true ) 
{
if ( m==0 ) 
{
return;
}
listbox.options[m-1].selected = true;
textbox.value=listbox.options[m-1].text;
return;
}
}

//listbox.options[0].selected=true;
}

}
}

function MoveUpAndDownValue(textbox2,listbox2)
{

var f = document.theSource;
var listbox = listbox2;
var textbox = textbox2;
if(event.keyCode=='38' ||event.keyCode=='40')
{
if(event.keyCode=='40')
{
for ( var m = 0; m < listbox.length; m++ )
{
if ( listbox.options[m].selected==true ) 
{
if ( m+1==listbox.length ) 
{
return;
}
listbox.options[m+1].selected = true;
textbox.value=listbox.options[m+1].text;

return;
}
}

listbox.options[0].selected=true;
}
if(event.keyCode=='38')
{
for ( var m = 0; m < listbox.length; m++ )
{
if ( listbox.options[m].selected==true ) 
{
if ( m==0 ) 
{
return;
}
listbox.options[m-1].selected = true;
textbox.value=listbox.options[m-1].text;
return;
}
}

//listbox.options[0].selected=true;
}

}
}

function suggestName( textbox2,listbox2,level)
{
if ( isNaN( level ) ) { level = 1 }
if(event.keyCode!=38 &&event.keyCode!=40&&event.keyCode!=13&&event.keyCode!=8)
{
//alert(textbox2.value);
//var f = document.theSource;
//var listbox = f.measureIndx;
//var textbox = f.measure_name;
var listbox = listbox2;
var textbox = textbox2;

var soFar = textbox.value.toString();
var soFarLeft = soFar.substring(0,level).toLowerCase();
var matched = false;
var suggestion = '';
var m
for (m  = 0; m < listbox.length; m++ ) {
suggestion = listbox.options[m].text.toString();
suggestion = suggestion.substring(0,level).toLowerCase();
if ( soFarLeft == suggestion ) {
listbox.options[m].selected = true;
matched = true;
break;
}

}
if ( matched && level < soFar.length ) { level++; suggestName(textbox,listbox,level) }
}

}


function suggestValue( textbox2,listbox2,level )
{
if ( isNaN( level ) ) { level = 1 }
if(event.keyCode!=38 &&event.keyCode!=40&&event.keyCode!=13)
{
var f = document.theSource;
var listbox = listbox2;
var textbox = textbox2;

var soFar = textbox.value.toString();
var soFarLeft = soFar.substring(0,level).toLowerCase();
var matched = false;
var suggestion = '';
for ( var m = 0; m < listbox.length; m++ ) {
suggestion = listbox.options[m].value.toString();
suggestion = suggestion.substring(0,level).toLowerCase();
if ( soFarLeft == suggestion ) {
listbox.options[m].selected = true;

matched = true;
break;
}
}
if ( matched && level < soFar.length ) { level++; suggestName(level) }
}
}




    </script>
    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="ScriptManager1" runat="server"></Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Consignment Return Report<br />
            </b>
            <br />
            <asp:Label ID="lblMsg" runat="server" ClientIDMode="Static" CssClass="ItDoseLblError"></asp:Label>

        </div>
        <div class="POuter_Box_Inventory">
   <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Consignment No
                            </label>
                            <b class="pull-right">:</b>
                            </div>
                        <div class="col-md-5">
                             <asp:TextBox ID="txtConsignmentNo" runat="server" />
                            </div>
                       
                    <div class="col-md-3">
                            <label class="pull-left">
                                Return No
                            </label>
                            <b class="pull-right">:</b>
                            </div>
                        <div class="col-md-5">
                             <asp:TextBox ID="txtReturnNo" runat="server"  />
                            </div>
                        </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Date From
                            </label>
                            <b class="pull-right">:</b>
                            </div>
                        <div class="col-md-5">
                              <asp:TextBox ID="txtFromDate" runat="server"></asp:TextBox>
                            </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Date To
                            </label>
                            <b class="pull-right">:</b>
                            </div>
                        <div class="col-md-5">
                             <asp:TextBox ID="txtToDate" runat="server"></asp:TextBox>
                            </div>
                        </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Vendor
                            </label>
                            <b class="pull-right">:</b>
                            </div>
                        <div class="col-md-5">
                             <asp:DropDownList ID="ddlVendor" runat="server" meta:resourcekey="ddlVendorResource1">
                            </asp:DropDownList>
                            </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Select Item
                            </label>
                            <b class="pull-right">:</b>
                            </div>
                        <div class="col-md-5">
                           <asp:TextBox ID="txtSearch" runat="server" AutoCompleteType="Disabled" CssClass="ItDoseTextinputText"
                                onkeydown="MoveUpAndDownText(ctl00$ContentPlaceHolder1$txtSearch,ctl00_ContentPlaceHolder1_ListBox1);"
                                onkeyup="suggestName(ctl00$ContentPlaceHolder1$txtSearch,ctl00_ContentPlaceHolder1_ListBox1);" meta:resourcekey="txtSearchResource1"></asp:TextBox>&nbsp;
                           
                            </div>
                        <div class="col-md-2">
                             <asp:Button ID="btnWord" runat="server" CausesValidation="false" CssClass="ItDoseButton"
                                OnClick="btnWord_Click" Text="Search" />
                                
                        </div>
                        <div class="col-md-1 pull-left">
                            <asp:Button ID="btnReset" Text="Reset" OnClick="btnReset_Click" runat="server" />
                            </div>
                        
                        </div>
                    <div class="row">
                        <div class="col-md-3">

                        </div>
                        <div class="col-md-5">
                            <asp:ListBox ID="ListBox1" runat="server" CssClass="ItDoseDropdownbox" Height="100px"
                                meta:resourcekey="ListBox1Resource1" Width="463px"></asp:ListBox>
                        </div>
                    </div>
                    <div class="row"></div>
                    <div class="row" align="center">
<asp:Button ID="btnSearch" runat="server" CssClass="ItDoseButton" Width="60px" Text="Search"
                OnClick="btnSearch_Click" />
                    </div>
                    </div>
                    </div>
       </div>
    </div>
    <div class="POuter_Box_Inventory" style="display:none;">
        <div class="content" style="text-align: center;">
            
        </div>
        <div class="Purchaseheader">
            Search Result
        </div>
        <asp:GridView ID="grdSearch" runat="server" Visible="false" EnableViewState="false" DataKeyNames="ReturnDate"
            CellPadding="3" AllowSorting="true" ShowHeader="true" ShowFooter="true" CssClass="GridViewStyle"
            AutoGenerateColumns="False" >
            <Columns>
                <asp:TemplateField HeaderText="S.No">
                    <ItemTemplate>
                        <%#Container.DataItemIndex+1 %>
                    </ItemTemplate>
                    <ItemStyle HorizontalAlign="Left" CssClass="GridViewItemStyle" />
                    <HeaderStyle Width="15px" />
                </asp:TemplateField>
                <asp:BoundField DataField="ConsignmentNo" HeaderText="ConsNo"></asp:BoundField>
                <asp:BoundField HeaderText="ReturnNo" DataField="ReturnNo"></asp:BoundField>
                <asp:BoundField HeaderText="Return Date" DataField="ReturnDate"></asp:BoundField>
                <asp:BoundField HeaderText="ItemName" DataField="ItemName"></asp:BoundField>
                <asp:BoundField HeaderText="BatchNo" DataField="BatchNumber"></asp:BoundField>
                <%--<asp:BoundField HeaderText="OpenQty" DataField="InititalCount" Visible="false"></asp:BoundField>--%>
                <%--<asp:BoundField HeaderText="IssuedQty" DataField="ReleasedCount" Visible="false"> </asp:BoundField>--%>
                <asp:BoundField HeaderText="ReturnedQty" DataField="ReturnedQuantity"></asp:BoundField>
                <asp:BoundField HeaderText="BalanceQty" DataField="BalanceQty" Visible="false"></asp:BoundField>
                <asp:BoundField HeaderText="UnitPrice" DataField="UnitPrice"></asp:BoundField>
                <asp:BoundField HeaderText="MRP" DataField="MRP"></asp:BoundField>
                <asp:BoundField HeaderText="Vendor Name" DataField="VendorName"></asp:BoundField>
                <asp:BoundField HeaderText="GateEntryNo" DataField="GateEntryNo"></asp:BoundField>
                <asp:BoundField HeaderText="GatePassNo" DataField="GatePassNo"></asp:BoundField>
                <asp:BoundField HeaderText="Reason" DataField="ReturnReason"></asp:BoundField>
                <asp:BoundField HeaderText="ReturnByUserName" DataField="ReturnedBy"></asp:BoundField>
            </Columns>
        </asp:GridView>
    </div>   
</asp:Content>
