require 'rubygems'
require 'bundler/setup'
require 'byebug'
require_relative 'RelativityWorkspace'
require_relative 'InputData'

class ProcessTranscript < RelativityWorkspace

  def iframe_documentViewer
    return $browser.iframe(:id=>"_documentViewer__documentIdentifierFrame")
  end
 
   def iframe_WordViewer
      return $browser.iframe(:id=>"_documentViewer__viewerFrame")
   end
   
    def iframe_WordIndex
      return self.iframe_WordViewer.iframe(:id=>"wordIndexBottomFrame")
   end

   def ValidateDocumentsCount
   	iframe_main.table(:id=>"ctl00_ctl00_itemList_listTable").trs.count    
   end
       
   def RunTranscriptProcess(header, footer)
      $browser.a(:class=>"returnLink").span(:class=>"returnText", :text=> "Return to document list").click
      iframe_main.a(:text=>"TRANS_00001").parent.parent.tds[1].wait_until_present.click
   	  iframe_main.select(:id=>"ctl00_checkedItemsActionToTake").option(:value=>"ProcessTranscript").select
    	iframe_main.a(:title => "Go").click
    	$browser.window(:index => 1).wait_until_present
      $browser.window(:index => 1).use do
      	$browser.text_field(:id=>"ctl03_textBox_textBox").wait_until_present.set(header)
      	$browser.text_field(:id=>"ctl04_textBox_textBox").wait_until_present.set(footer)
      	$browser.a(:title=>"Run").click
      end
      $browser.window(:index => 0).wait_until_present
      $browser.window(:index => 0).use do
         iframe_main.tr(:id=>"ctl00_ctl00_itemList_ctl00_ctl00_itemList_ROW0").a(:class=>"itemListPrimaryLink").wait_until_present
      end
    end 

  def ValidateProcessedtransacript(number,header,footer,word1)
    iframe_main.a(:text=>number).click
    iframe_documentViewer.td(:class=>"identifierCell").span(:text=>number).wait_until_present(120)
    iframe_WordViewer.div(:id=>"toolbarBottomRight").span(:class=>"charm-outer icon-viewer-word-index").wait_until_present(120).click
    iframe_WordIndex.text_field(:id=>"_wordindex_ctl00_itemList_FILTER-BOOLEANSEARCH[Word]-T").set(word1)
    $browser.send_keys(:return)
    iframe_WordIndex.tr(:id=>"_wordindex_ctl00_itemList__wordindex_ctl00_itemList_ROW0").tds[2].as[0].wait_until_present.click
    iframe_WordViewer.div(:id=>"viewerContainer").span(:text=>word1).exists?
    iframe_WordViewer.div(:id=>"viewerContainer").span(:text=>header).exists?
    iframe_WordViewer.div(:id=>"viewerContainer").span(:text=>footer).exists?
  end 

end