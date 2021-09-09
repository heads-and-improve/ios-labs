//
//  AutoResizingTextViewController.swift
//  iOS Labs
//
//  Created by Андрей Исаев on 09.09.2021.
//

import UIKit

final class AutoResizingTextViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.attributedText = NSAttributedString(
            string: "История названий Новосибирска",
            style: TextStyleSet.current.title
        )

        bodyLabel.attributedText = NSAttributedString(
            string: """
            Возник в 1893 году как селение Новая Деревня (неофициальное название — Гусевка) в связи с постройкой железнодорожного моста через реку Обь при проведении Транссибирской магистрали. В 1894 году Новая Деревня переименована в посёлок Александровский, в честь императора Александра III, инициатора строительства Транссиба, а уже в 1895 году посёлок переименован в Новониколаевский в честь императора Николая II. В 1903 году преобразован в безуездный город Новониколаевск. Компонента ново- включена в название для отличия от названий двух других существовавших тогда городов с названием «Николаевск»: в устье Амура (с 1926 года — Николаевск-на-Амуре) и в Заволжье (с 1918 года — Пугачёв). В 1926 году Новониколаевск переименован в Новосибирск.
            """,
            style: TextStyleSet.current.body.colored(ColorPalette.current.text)
        )

        view.backgroundColor = ColorPalette.current.background
        
        let button = UIButton()
        button.setImage(ImageKey.share.image, for: .normal)
    }

}
