<%@ Page  Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="PostLaundryItem.aspx.cs" Inherits="Design_Laundry_PostLaundryItem" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, 
PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

     <Ajax:ScriptManager ID="ScriptManager2" runat="server"
        EnableScriptGlobalization="true" EnableScriptLocalization="true" />

    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Laundry Post Item</b><br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" ClientIDMode="Static">
            </asp:Label>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center;">
         <div id="laundryOutput" style="max-height: 300px; overflow-x: auto;text-align:center">
                        </div>
             <br />
             <input type="button" id="btnPost" class="ItDoseButton" value="Post" onclick="postItem()"  style="display:none"/>

        </div>
        </div>
    
    <script id="tb_LaundryData" type="text/html">
   <table class="GridViewStyle" cellspacing="0" rules="all" border="1"   id="grdLaundry"
    style="border-collapse:collapse;width:560px">
		<tr id="Header">
			<th class="GridViewHeaderStyle" scope="col" style="width:40px;">S.No.
                <input type="checkbox" class="chkAll" onclick="checkAll(this)"  />
			</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:240px;">Item Name</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:60px;">Qty.</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:60px;">IsWashing</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:60px;">IsDryer</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:60px;">IsIroning</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:90px;display:none">StockID</th>			
            <th class="GridViewHeaderStyle" scope="col" style="width:10px;display:none">ItemID </th> 
            <th class="GridViewHeaderStyle" scope="col" style="width:10px;display:none">ID </th>  
            <th class="GridViewHeaderStyle" scope="col" style="width:10px;display:none">IsProcess </th>            			
       </tr>
       <#
              var dataLength=laundryData.length;
              var objRow; 
              for(var j=0;j<dataLength;j++)
               {                 
                  objRow = laundryData[j];   
        #>
                    <tr >
       <td class="GridViewLabItemStyle"><#=j+1#>
    <input type="checkbox" id="chk" checked="checked"  class="chkPost" onclick="checkPostCon(this)" />
      </td>
      <td id="tdItemName"  class="GridViewLabItemStyle" style="width:240px;"><#=objRow.ItemName#></td>
      <td id="tdReturnQty"  class="GridViewLabItemStyle" style="width:40px;text-align:right"><#=objRow.ReturnQty#></td>
      <td id="tdIsWashing"  class="GridViewLabItemStyle" style="text-align:center;width:60px;"><#=objRow.IsWashing#></td>
      <td id="tdIsDryer"  class="GridViewLabItemStyle" style="text-align:center;width:60px;"><#=objRow.IsDryer#></td>
      <td id="tdIsIroning"  class="GridViewLabItemStyle" style="text-align:center;width:60px;"><#=objRow.IsIroning#></td>
      <td id="tdStockID"  class="GridViewLabItemStyle" style="width:100px;text-align:right;display:none"><#=objRow.StockID#></td>                    
      <td id="tdItemID"  class="GridViewLabItemStyle" style="width:100px;text-align:right;display:none"><#=objRow.ItemID#></td>                    
      <td id="tdID"  class="GridViewLabItemStyle" style="width:100px;text-align:right;display:none"><#=objRow.ID#></td>                    
      <td id="tdIsProcess"  class="GridViewLabItemStyle" style="width:100px;text-align:right;display:none"><#=objRow.IsProcess#></td>                      
                           </tr>
            <#}#>
     </table>    
    </script>  
     <script type="text/javascript" >
         function checkPostCon(rowID) {
             var chkLength = $("#grdLaundry tr").not('#Header').length;
             if ($('#grdLaundry tr').filter(':has(:checkbox:checked)').find("#chk").length > 0) {
                 $("#btnPost").show();
             }
             else {
                 $("#btnPost").hide();
             }
         }
         function checkAll(rowID) {
             if ($(".chkAll").is(':checked')) {
                 $(".chkPost").attr("checked", "checked");
                 $("#btnPost").show();
             }
             else {
                 $(".chkPost").attr("checked", false);
                 $("#btnPost").hide();
             }
         }
         </script>  

    <script type="text/javascript">
        $(function () {
            btnSeach();
        });
        function btnSeach() {
            $("#lblMsg").text('');
                $.ajax({
                    url: "Services/LaundryService.asmx/laundryPost",
                    data: '{}',
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    timeout: 120000,
                    async: false,
                    dataType: "json",
                    success: function (result) {
                        laundryData = jQuery.parseJSON(result.d);
                        if (laundryData != "") {
                            var output = $('#tb_LaundryData').parseTemplate(laundryData);
                            $('#laundryOutput').html(output).show();
                            $('#btnPost').removeAttr('disabled').show();

                            $("#grdLaundry tr").each(function () {
                                var id = $(this).closest("tr").attr("id");
                                if (id != "Header") {
                                    if (($(this).find('#tdIsProcess').html() == "1") || ($(this).find('#tdIsProcess').html() == "2"))
                                    {
                                        $(this).find("#chk").attr('checked', false);
                                        $(this).find("#chk").attr('disabled', 'disabled').removeClass('chkPost');
                                    }
                                }

                            });
                        }
                        else {
                            $('#laundryOutput').html('');
                            $('#laundryOutput,#btnPost').hide();
                           // DisplayMsg('MM04', 'lblMsg');
                        }
                    },
                    error: function (xhr, status) {
                       // DisplayMsg('MM05', 'lblMsg');
                    }
                });
            
        }
    </script>
    <script type="text/javascript">
        function postItem() {
            var chkLength = $('#grdLaundry tr').filter(':has(:checkbox:checked)').find("#chk").length;
            if (chkLength > 0) {
                $('#btnPost').attr('disabled', true);
                var data = new Array();
                $("#grdLaundry tr").each(function () {
                    var id = $(this).closest("tr").attr("id");
                    if (id != "Header") {
                        if ($(this).find('#chk').is(':checked')) {
                            var obj = new Object();
                            obj.StockID = $(this).find('#tdStockID').html();
                            obj.ID = $(this).find('#tdID').html();
                            
                            data.push(obj);
                        }
                    }

                });
                $.ajax({
                    url: "Services/LaundryService.asmx/PostLaundryData",
                    data: JSON.stringify({ postLaundry: data }),
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    timeout: 120000,
                    async: false,
                    dataType: "json",
                    cache: false,
                    success: function (result) {
                        if (result.d == "1") {                                           
                            $('#laundryOutput').html('');
                            $('#laundryOutput,#btnPost').hide();
                            btnSeach();
                            DisplayMsg('MM01', 'lblMsg');

                        }
                        else {
                            DisplayMsg('MM05', 'lblMsg');
                        }
                    },
                    error: function (xhr, status) {
                        DisplayMsg('MM05', 'lblMsg');
                        $('#btnPost').removeAttr('disabled').hide();
                    }
                });

            }
            else {
                $("#<%=lblMsg.ClientID%>").text('Please Select Post Item');
                return;
            }
        }
    </script>
</asp:Content>

